extends CharacterBody2D

signal life_changed(new_value: int)

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var damage : int = 10
@export var fireball : PackedScene
@export var fireball_speed = 400.0

enum {IDLE, RUN, ATTACK, DYING, JUMP}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var life = 100
var is_short_attack_on_cooldown = false
var is_range_attack_on_cooldown = false
var color_as_text = "black"
var state = IDLE
var is_invincible = false
const FLOAT_PRECISION = 0.0001

func _on_background_color_changed(bkg_color: Enums.LightColor):
	match bkg_color :
		Enums.LightColor.BLACK:
			color_as_text = "white"
		Enums.LightColor.WHITE:
			color_as_text = "black" 

func take_damage(damage: int):
	if state == DYING:
		return
	life -= damage
	if life < 0:
		life = 0
		state = DYING
		$DeathSFX.play()
		print_debug("Die")
	else:
		is_invincible = true
		$InvincibilityTimer.start()
		$HitSFX.play()
	emit_signal("life_changed", life)
	
func short_attack():
	var other_areas: Array[Area2D] = $Body/AttackArea.get_overlapping_areas()
	is_short_attack_on_cooldown = true
	$ShortAttackCooldownTimer.start()
	$EffortSFX.play()
	if other_areas.is_empty():
		$SwordMissSound.play()
	else: 
		$SwordHitSound.play()
	
	for area in other_areas:
		if area.has_method("take_damage"):
			if area.color_as_text == color_as_text :
				area.take_damage(damage)
			
func range_attack():
	var fireball_instance : Projectile = fireball.instantiate()
	var direction = global_position.direction_to(get_global_mouse_position()) 
	var fireball_real_speed = fireball_speed
	if direction.x * velocity.x > 0:
		fireball_real_speed += abs(velocity.x) 
	fireball_instance.launch($Body/ProjectileSpawn.global_position, direction*fireball_real_speed, color_as_text, true)
	get_parent().add_child(fireball_instance)
	is_range_attack_on_cooldown = true
	$RangeAttackCooldownTimer.start()
	
	
func reset_short_attack_cooldown():
	is_short_attack_on_cooldown = false
	
func reset_range_attack_cooldown():
	is_range_attack_on_cooldown = false

func set_animation(anim: String):
	$Body/Sprite.animation = anim + "_" + color_as_text 

func _ready():
	emit_signal("life_changed", life)
	$ShortAttackTimer.timeout.connect(short_attack)
	$ShortAttackCooldownTimer.timeout.connect(reset_short_attack_cooldown)
	$RangeAttackCooldownTimer.timeout.connect(reset_range_attack_cooldown)
	$Body/Sprite.play()
	$Body/Sprite.animation_looped.connect(_on_sprite_animation_looped)
	
func _physics_process(delta):
	if state == DYING:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if state == IDLE or state == RUN:
			velocity.y = jump_velocity
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if abs(direction) > FLOAT_PRECISION:
		if state == IDLE or state == RUN or state == JUMP:
			velocity.x = direction * speed
			$Body.scale.x = sign(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	update_player_state(is_on_floor(), direction, velocity.x)

	move_and_slide()

#calulate new player state
func update_player_state(is_on_floor: bool, direction_input: float, velocity_x: float):
	if state != ATTACK or is_invincible:
		if not is_on_floor:
			state = JUMP
		else:
			if abs(direction_input) > FLOAT_PRECISION and abs(velocity_x) > FLOAT_PRECISION:
				state = RUN
			else:
				state = IDLE
	
func _process(delta):
	#set animation
	if is_invincible:
		set_animation("hit")
		$Body/Sprite.modulate = Color(1.0,1.0,1.0,0.5)
	else:
		$Body/Sprite.modulate = Color(1.0,1.0,1.0,1.0)
		match state:
			IDLE:
				set_animation("idle")
			ATTACK:
				set_animation("atk")
			RUN:
				set_animation("run")
			JUMP:
				set_animation("jump")
			DYING:
				set_animation("death")
		

func _unhandled_input(event):
	if state == DYING or is_invincible:
		return
	if event.is_action_pressed("attack_short") and not is_short_attack_on_cooldown:
		$ShortAttackTimer.start()
		state = ATTACK
	if event.is_action_pressed("attack_range") and not is_range_attack_on_cooldown:
		range_attack()


func _on_invincibility_timer_timeout():
	is_invincible = false


func _on_sprite_animation_looped():
	if state == ATTACK:
		state = IDLE

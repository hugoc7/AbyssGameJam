extends CharacterBody2D

signal life_changed(new_value: int)

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var damage : int = 10


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var life = 100
var is_short_attack_on_cooldown = false

func take_damage(damage: int):
	life -= damage
	if life < 0:
		life = 0
	emit_signal("life_changed", life)
	
func short_attack():
	var other_areas: Array[Area2D] = $AttackArea.get_overlapping_areas()
	print_debug("player short atk")	
	is_short_attack_on_cooldown = true
	$ShortAttackCooldownTimer.start()
	if other_areas.is_empty():
		$SwordMissSound.play()
	else: 
		$SwordHitSound.play()
	
	for area in other_areas:
		if area.has_method("take_damage"):
			area.take_damage(damage)
	
func reset_short_attack_cooldown():
	is_short_attack_on_cooldown = false

func _ready():
	emit_signal("life_changed", life)
	$ShortAttackTimer.timeout.connect(short_attack)
	$ShortAttackCooldownTimer.timeout.connect(reset_short_attack_cooldown)
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		$Sprite2D.scale.x = sign(direction) * abs($Sprite2D.scale.x)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("attack_short") and not is_short_attack_on_cooldown:
		$ShortAttackTimer.start()
	if event is InputEventMouseMotion:
		var mouse = get_global_mouse_position()

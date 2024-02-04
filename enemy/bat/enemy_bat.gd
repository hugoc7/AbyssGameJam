@tool
extends Area2D

class_name EnemyBat

@export var color = Enums.LightColor.WHITE
@export var white_texture : Texture2D = null
@export var black_texture : Texture2D = null
@export var player : Node2D = null
@export var purchase_distance = Vector2(250,1200) # (min, max)
@export var speed : float = 50.0
@export var damage : int = 10
@export var attack_range : float = 200
@export var life = 100
@export var explosion_vfx : PackedScene
@export var projectile : PackedScene
@export var projectile_speed = 300.0
@export var turnaround_cooldown_duration : float = 5

const x_oscilate_period:int = 100
const y_speed: float = 150

var color_as_text = "white" 
@onready var sprite : AnimatedSprite2D = $Sprite

var is_in_cooldown = false

var turnaround_timer : SceneTreeTimer = null

func take_damage(damage_taken):
	set_animation("hit")
	life -= damage_taken
	if life <= 0:
		die()
	else:
		$Hit_SFX.play()

func die():
	set_animation("death")
	queue_free()
	$Death_SFX.play()
	var explosion_instance = explosion_vfx.instantiate()
	explosion_instance.position = position
	get_parent().add_child(explosion_instance)

func set_animation(anim: String):
	sprite.animation = anim + "_" + color_as_text 

func fire_projectile():
	set_animation("atk")
	var projectile_instance : Projectile = projectile.instantiate()
	projectile_instance.damage = self.damage
	projectile_instance.collision_layer = 5
	projectile_instance.collision_mask = 9
	projectile_instance.launch(position, projectile_speed*global_position.direction_to(player.global_position))
	get_parent().add_child(projectile_instance)

func _ready():
	if color == Enums.LightColor.WHITE:
		color_as_text = "white"
	elif color == Enums.LightColor.BLACK:
		color_as_text = "black"
	set_animation("idle")
	
	if Engine.is_editor_hint():
		set_process(false)
		return
	
	sprite.play(sprite.animation)
	turnaround_timer = get_tree().create_timer(0)
	body_entered.connect(_on_body_entered)
	$CooldownTimer.timeout.connect(_on_cooldown_timeout)
	
	
	
func _on_background_color_changed(bkg_color: Enums.LightColor):
	sprite.visible = bkg_color != color
	
func _process(delta):
	if player == null:
		return
		
	var sqr_dist_to_player = global_position.distance_squared_to(player.global_position)
	if $AttackTimer.is_stopped() and sqr_dist_to_player < attack_range * attack_range:
		$AttackTimer.start()
	
	if sqr_dist_to_player < purchase_distance.y * purchase_distance.y:
		#print_debug(sqrt(sqr_dist_to_player)," ", purchase_distance.y," ", purchase_distance.x," ",turnaround_timer.time_left)
		if sqr_dist_to_player < purchase_distance.x * purchase_distance.x:
				turnaround_timer = get_tree().create_timer(turnaround_cooldown_duration)

		if turnaround_timer.time_left != 0: # no cooldown, chase
			var direction = sign(global_position.x - player.global_position.x)
			global_position.x += direction * speed * delta
			sprite.scale.x = direction * abs(sprite.scale.x)			
		else: # cooldown, evade
			var direction = sign(player.global_position.x - global_position.x)

			global_position.x += direction * speed * delta
			sprite.scale.x = direction * abs(sprite.scale.x)

		global_position.y += y_speed * delta * (abs(abs(int(global_position.x) % x_oscilate_period) - x_oscilate_period/ 2 )-x_oscilate_period/4)/x_oscilate_period*4

			
	if sqr_dist_to_player < attack_range*attack_range and not is_in_cooldown:
		_damage_player()
		is_in_cooldown = true
		$CooldownTimer.start()

func _damage_player():
	if player == null:
		return
	player.take_damage(damage)
	#print_debug("atk player")

func _on_cooldown_timeout():
	is_in_cooldown = false

func _on_body_entered(body):
	pass
	#_damage_player()
	

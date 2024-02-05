@tool
extends Area2D

class_name EnemyContact

signal died()

@export var color = Enums.LightColor.WHITE
@export var white_texture : Texture2D = null
@export var black_texture : Texture2D = null
@export var player : Node2D = null
@export var purchase_distance = Vector2(100,1000)
@export var speed : float = 50.0
@export var damage : int = 10
@export var attack_range : float = 200
@export var life = 20
@export var shielded = false
@export var shield_health = 10
@export var shield_color = Enums.LightColor.WHITE
@export var die_vfx : PackedScene

var is_in_cooldown = false
var is_dying = false
var is_attacking = false
var is_attacked = false
var color_as_text = "white" 
@onready var sprite : AnimatedSprite2D = $Sprite
@onready var shield = $Shield

func take_damage(damage_taken: int):
	if is_dying: 
		return
	set_animation("hit")
	is_attacked = true
	life -= damage_taken
	if life <= 0:
		life = 0
		die()
	else:
		$Hit_SFX.play()

func die():
	set_animation("death")
	$Death_SFX.play()
	var die_vfx_instance = die_vfx.instantiate()
	die_vfx_instance.position = position
	get_parent().add_child(die_vfx_instance)
	is_dying = true	

func set_animation(anim: String):
	sprite.animation = anim + "_" + color_as_text 

func _ready():
	if color == Enums.LightColor.WHITE:
		color_as_text = "white"
	elif color == Enums.LightColor.BLACK:
		color_as_text = "black"
	set_animation("idle")
	_change_color("white")
	
	if Engine.is_editor_hint():
		set_process(false)
		return
	
	if shielded:
		shield._create_shield(shield_health, shield_color)
	
	sprite.play(sprite.animation)
	$CooldownTimer.timeout.connect(_on_cooldown_timeout)
	$AttackTimer.timeout.connect(_attack_player)

func _on_background_color_changed(bkg_color: Enums.LightColor):
	match bkg_color:
		Enums.LightColor.BLACK:
			_change_color("black")
		Enums.LightColor.WHITE:
			_change_color("white")

func _change_color(color : String):
	if color == color_as_text:
		sprite.self_modulate.a = 0.5
	else:
		sprite.self_modulate.a = 1

func _process(delta):
	if player == null or is_dying:
		return
	var sqr_dist_to_player = global_position.distance_squared_to(player.position)
	if sqr_dist_to_player < purchase_distance.y * purchase_distance.y:
		if sqr_dist_to_player < attack_range*attack_range and not is_in_cooldown:
			is_in_cooldown = true
			set_animation("atk")
			is_attacking = true
			$Effort_SFX.play()
			$AttackTimer.start()
		elif sqr_dist_to_player > purchase_distance.x * purchase_distance.x:
			if not is_attacked and not is_attacking:
				var direction = sign(player.global_position.x - global_position.x)
				global_position.x += direction * speed * delta
				set_animation("run")
				#if $Sprite2D.scale.x * direction < 0:
				sprite.scale.x = direction * abs(sprite.scale.x)
		elif not is_attacked and not is_attacking:
			set_animation("idle")

func _attack_player():
	$CooldownTimer.start()	
	if player == null:
		return
	if global_position.distance_to(player.global_position) < attack_range:
		player.take_damage(damage)

func _on_cooldown_timeout():
	is_in_cooldown = false

func _on_sprite_animation_loop():
	if is_dying:
		queue_free()
	if is_attacking:
		is_attacking = false
	if is_attacked:
		is_attacked = false

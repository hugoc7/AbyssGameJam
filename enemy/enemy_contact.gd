@tool
extends Area2D

class_name EnemyContact

@export var color = Enums.LightColor.WHITE
@export var white_texture : Texture2D = null
@export var black_texture : Texture2D = null
@export var player : Node2D = null
@export var purchase_distance = Vector2(100,1000)
@export var speed : float = 50.0
@export var damage : int = 10
@export var attack_range : float = 200
@export var life = 10

var is_in_cooldown = false

func take_damage(damage: int):
	life -= damage
	if life < 0:
		life = 0
		die()
		
func die():
	queue_free()

func _ready():
	if color == Enums.LightColor.WHITE:
		$Sprite2D.set_texture(white_texture)
	elif color == Enums.LightColor.BLACK:
		$Sprite2D.set_texture(black_texture)
	
	if Engine.is_editor_hint():
		set_process(false)
		return
	
	body_entered.connect(_on_body_entered)
	$CooldownTimer.timeout.connect(_on_cooldown_timeout)
		
	
	
func _on_background_color_changed(bkg_color: Enums.LightColor):
	$Sprite2D.visible = bkg_color != color
	
func _process(delta):
	if player == null:
		return
	var sqr_dist_to_player = global_position.distance_squared_to(player.position)
	if sqr_dist_to_player < purchase_distance.y * purchase_distance.y:
		if sqr_dist_to_player > purchase_distance.x * purchase_distance.x:
			var direction = sign(player.global_position.x - global_position.x)
			global_position.x += direction * speed * delta
			#if $Sprite2D.scale.x * direction < 0:
			$Sprite2D.scale.x = direction * abs($Sprite2D.scale.x)
	if sqr_dist_to_player < attack_range*attack_range and not is_in_cooldown:
		_damage_player()
		is_in_cooldown = true
		$CooldownTimer.start()

func _damage_player():
	if player == null:
		return
	player.take_damage(damage)
	print_debug("atk player")

func _on_cooldown_timeout():
	is_in_cooldown = false

func _on_body_entered(body):
	pass
	#_damage_player()
	

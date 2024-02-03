@tool
extends Area2D

class_name EnemyContact

@export var color = Enums.LightColor.WHITE
@export var white_texture : Texture2D = null
@export var black_texture : Texture2D = null
@export var player : Node2D = null
@export var purchase_distance = Vector2(100,1000)
@export var speed : float = 50.0

func _ready():
	if color == Enums.LightColor.WHITE:
		$Sprite2D.set_texture(white_texture)
	elif color == Enums.LightColor.BLACK:
		$Sprite2D.set_texture(black_texture)
	
func _on_background_color_changed(bkg_color: Enums.LightColor):
	$Sprite2D.visible = bkg_color != color
	
func _process(delta):
	if player == null:
		return
	var sqr_dist_to_player = global_position.distance_squared_to(player.position)
	if sqr_dist_to_player < purchase_distance.y * purchase_distance.y:
		if sqr_dist_to_player > purchase_distance.x * purchase_distance.x:
			global_position.x += sign(player.global_position.x - global_position.x) * speed * delta
		
		
	
	
	


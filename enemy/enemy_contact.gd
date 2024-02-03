@tool
extends CharacterBody2D

class_name EnemyContact

@export var color = Enums.LightColor.WHITE
@export var white_texture : Texture2D
@export var black_texture : Texture2D

func _ready():
	if color == Enums.LightColor.WHITE:
		$Sprite2D.set_texture(white_texture)
	elif color == Enums.LightColor.BLACK:
		$Sprite2D.set_texture(black_texture)
	
func _on_background_color_changed(bkg_color: Enums.LightColor):
	$Sprite2D.visible = bkg_color != color
	


extends CharacterBody2D

enum LightColor {WHITE, BLACK}

@export var color = LightColor.WHITE
@export var white_texture : Texture2D
@export var black_texture : Texture2D

func _ready():
	if color == LightColor.WHITE:
		$Sprite2D.texture = white_texture
	elif color == LightColor.BLACK:
		$Sprite2D.set_texture(black_texture)
	


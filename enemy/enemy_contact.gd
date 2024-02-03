@tool
extends CharacterBody2D



@export var color = Enums.LightColor.WHITE
@export var white_texture : Texture2D
@export var black_texture : Texture2D

func _ready():
	if color == Enums.LightColor.WHITE:
		$Sprite2D.set_texture(white_texture)
	elif color == Enums.LightColor.BLACK:
		$Sprite2D.set_texture(black_texture)
	


@tool
extends Sprite2D


@export var default_color = Enums.LightColor.WHITE
@export var black_texture : Texture2D
@export var white_texture : Texture2D

func _ready():
	update_color(default_color)
		
func update_color(color: Enums.LightColor):
	if color == Enums.LightColor.WHITE:
		set_texture(white_texture)
	elif color == Enums.LightColor.BLACK:
		set_texture(black_texture)

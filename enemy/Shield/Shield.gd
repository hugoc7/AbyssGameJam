extends Node2D

var color_as_text = "white"
var enabled : bool = false
var shieldhealth = 10

var Owner : Node

var is_exploding = false


func _create_shield(health : int, color : Enums.LightColor):
	Level.Game_Manager.level_color_state_changed.connect(_on_background_color_changed)
	enabled = true
	match color:
		Enums.LightColor.WHITE:
			color_as_text = "white"
		Enums.LightColor.BLACK:
			color_as_text = "black"
	shieldhealth = health
	$Sprite.visible = true
	set_animation("loop")
	$Sprite.play()

func take_damage(damage : int):
	shieldhealth -= damage
	if shieldhealth <= 0:
		_shield_destroy()

func set_animation(anim: String):
	$Sprite.animation = anim + "_" + color_as_text 

func _shield_destroy():
	enabled = false
	is_exploding = true
	$Shield_Destroyed_SFX.play()
	set_animation("explosion")

func _on_background_color_changed(bkg_color: Enums.LightColor):
	match bkg_color:
		Enums.LightColor.BLACK:
			_change_color("black")
		Enums.LightColor.WHITE:
			_change_color("white")

func _change_color(color : String):
	if color == color_as_text:
		$Sprite.self_modulate.a = 0.5
	else:
		$Sprite.self_modulate.a = 1


func _on_sprite_animation_looped():
	if is_exploding:
		$Sprite.visible = false
		$Sprite.stop()

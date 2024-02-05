extends Area2D

class_name Projectile

var color_as_text = "white"
var speed = Vector2.ZERO
var damage = 100
var is_player = false

func launch(pos: Vector2, speed: Vector2, color: String, player: bool):
	self.position = pos
	self.speed = speed
	rotation = Vector2.RIGHT.angle_to(speed)
	Level.Game_Manager.level_color_state_changed.connect(_on_background_color_changed)
	is_player = player
	color_as_text = color
	$Sprite.animation = "loop_" + color
	$Sprite.play()

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

func destroy():
	queue_free()
	
func _process(delta):
	position += speed*delta
	

func _on_area_entered(area):
	if area.has_method("take_damage"):
		if is_player:
			if area.color_as_text == color_as_text:
				area.take_damage(damage)
		else:
			area.take_damage(damage)
		destroy()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		if is_player:
			if body.color_as_text == color_as_text:
				body.take_damage(damage)
		else:
			body.take_damage(damage)
		destroy()
	


func _on_destroy_timer_timeout():
	destroy()

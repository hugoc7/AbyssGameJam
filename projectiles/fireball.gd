extends Area2D

class_name Projectile

var speed = Vector2.ZERO
var damage = 100

func launch(pos: Vector2, speed: Vector2, color: String):
	self.position = pos
	self.speed = speed
	rotation = Vector2.RIGHT.angle_to(speed)
	$Sprite.animation = "loop_" + color
	$Sprite.play()

func destroy():
	queue_free()
	
func _process(delta):
	position += speed*delta
	

func _on_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage(damage)
	destroy()
	
	


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	destroy()


func _on_destroy_timer_timeout():
	destroy()

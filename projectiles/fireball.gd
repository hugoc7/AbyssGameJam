extends Area2D

class_name Projectile

var speed = Vector2.ZERO
var damage = 100


func launch(pos: Vector2, speed: Vector2):
	self.position = pos
	self.speed = speed
	rotation = Vector2.RIGHT.angle_to(speed)	

func destroy():
	queue_free()
	
func _process(delta):
	position += speed*delta
	

func _on_area_entered(area):
	destroy()
	
	if area.has_method("take_damage"):
		area.take_damage(damage)


func _on_body_entered(body):
	destroy()


func _on_destroy_timer_timeout():
	destroy()

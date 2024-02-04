extends Camera2D

@export var target : Node2D = null

func _process(delta):
	if target:
		position.x = target.position.x

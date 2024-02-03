extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	finished.connect(_on_finished)
	emitting = true

func _on_finished():
	queue_free()

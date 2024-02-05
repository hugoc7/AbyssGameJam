extends Control

@export var first_level : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Title.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_packed(first_level)

func _on_quit_pressed():
	get_tree().quit()

extends Node

var level_color_state = Enums.LightColor.WHITE

func _switch_color():
	if level_color_state == Enums.LightColor.WHITE:
		level_color_state = Enums.LightColor.BLACK
	else:
		level_color_state = Enums.LightColor.WHITE
	$Background.update_color(level_color_state)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug_switch_level_color"):
		_switch_color()
		

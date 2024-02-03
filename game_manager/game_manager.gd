extends Node

@export var world_rect : Rect2 = Rect2(-2000, -2000, 4000, 4000)


signal level_color_state_changed(color: Enums.LightColor)

var level_color_state = Enums.LightColor.WHITE

func _switch_color():
	if level_color_state == Enums.LightColor.WHITE:
		level_color_state = Enums.LightColor.BLACK
	else:
		level_color_state = Enums.LightColor.WHITE
	$Background.update_color(level_color_state)
	emit_signal("level_color_state_changed", level_color_state)

# Called when the node enters the scene tree for the first time.
func _ready():
	for enemy in $Enemy.get_children():
		level_color_state_changed.connect(enemy._on_background_color_changed)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug_switch_level_color"):
		_switch_color()
		
	# si le joueur sort du monde on le remet au spawn
	if not world_rect.has_point($Player.position):
		print_debug("Le joueur est sorti du monde. Replacer au spwan.")
		$Player.position = $PlayerSpawn.position
		

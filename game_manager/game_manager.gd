extends Node

@export var world_rect : Rect2 = Rect2(-2000, -2000, 4000, 4000)
@export var main_menu : PackedScene = null

@export var enemy_count = 0

signal level_color_state_changed(color: Enums.LightColor)

var level_color_state = Enums.LightColor.WHITE


func _switch_color():
	if level_color_state == Enums.LightColor.WHITE:
		level_color_state = Enums.LightColor.BLACK
	else:
		level_color_state = Enums.LightColor.WHITE
	
	
	
	if get_node_or_null("ParallaxBackground"):
		for layer: ParallaxLayer in $ParallaxBackground.get_children():
			for sprite:Sprite2D in layer.get_children():
				sprite.update_color(level_color_state)
	
	#$ParallaxBackground/ParallaxLayer/Background.update_color(level_color_state)
	emit_signal("level_color_state_changed", level_color_state)

func _init():
	Level.Game_Manager = self

func _ready():
	enemy_count = $Enemy.get_children().size()
	for enemy in $Enemy.get_children():
		level_color_state_changed.connect(enemy._on_background_color_changed)
	$Player.life_changed.connect(_on_life_changed)


func _on_life_changed(life: int):
	if life <= 0:
		get_tree().change_scene_to_file("res://menu/gameover.tscn")

func _process(delta):
	if Input.is_action_just_pressed("switch_level_color"):
		_switch_color()
		
	# si le joueur sort du monde on le remet au spawn
	if not world_rect.has_point($Player.position):
		print_debug("Le joueur est sorti du monde. Replacer au spwan.")
		$Player.position = $PlayerSpawn.position

func monster_died():
	enemy_count -= 1
	if enemy_count <= 0:
		win()

func win():
	get_tree().change_scene_to_file("res://menu/victory.tscn")

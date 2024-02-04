extends CanvasLayer

@export var heart_full : Texture2D
@export var heart_empty : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_player_life_changed(new_value):
	var life_nb = int(new_value/10)
	var hearts: Array[Node] = $Panel_full.get_children()
	for i in range(life_nb):
		hearts[i].texture = heart_full
	for i in range(life_nb, 10):
		hearts[i].texture = heart_empty
		
	
	
	
	#$ProgressBar.set_value(new_value)

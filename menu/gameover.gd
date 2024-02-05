extends Control



func _on_quit_button_down():
	$Quit/Node2D/fond.play()
	$Quit/Node2D/text.play()
	

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://levels/Level_Designtest.tscn")

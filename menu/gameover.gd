extends Control


func _on_quit_pressed():
	$Quit/Node2D/fond.play()
	$Quit/Node2D/text.play()

func _on_credits_pressed():
	$Credits/Node2D/text.play()
	$Credits/Node2D/text.play()

func _on_return_pressed():
	$Return/Node2D/fond.play()
	$Return/Node2D/text.play()



func _on_credits_animation_finished():
	get_tree().change_scene_to_file("res://menu/credits.tscn")
	


func _on_return_animation_finished():
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")


func _on_retry_animation_finished():
	get_tree().change_scene_to_file("res://levels/Level_Designtest.tscn")

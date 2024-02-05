extends Control

func _ready():
	$Title.play()


func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://levels/Level_Designtest.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://menu/credits.tscn")


func _on_play_button_down():
	$Play/Node2D/fond.play()
	$Play/Node2D/text.play()


func _on_credits_button_down():
	$Credits/Node2D/fond.play()
	$Credits/Node2D/text.play()
	

func _on_quit_button_down():
	$Quit/Node2D/fond.play()
	$Quit/Node2D/text.play()

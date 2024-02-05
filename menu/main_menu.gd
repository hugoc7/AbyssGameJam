extends Control

func _ready():
	$Title.play()


func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://levels/Level_Designtest.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://menu/credits.tscn")

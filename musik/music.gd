extends Node


func _unhandled_input(event):
	if Input.is_action_just_pressed("mute"):
		$player.stream_paused = not $player.stream_paused
			
		

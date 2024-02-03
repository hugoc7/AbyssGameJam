@tool
extends Area2D

class_name EnemyBat

@export var color = Enums.LightColor.WHITE
@export var white_texture : Texture2D = null
@export var black_texture : Texture2D = null
@export var player : Node2D = null
const purchase_distance = Vector2(200,900) # (min, max)
@export var speed : float = 50.0
@export var damage : int = 10
@export var attack_range : float = 200

var is_in_cooldown = false

const turnaround_cooldown_duration : float = 3
var turnaround_timer : SceneTreeTimer = null


func _ready():
	if color == Enums.LightColor.WHITE:
		$Sprite2D.set_texture(white_texture)
	elif color == Enums.LightColor.BLACK:
		$Sprite2D.set_texture(black_texture)
		
	
	if Engine.is_editor_hint():
		set_process(false)
		return
	
	turnaround_timer = get_tree().create_timer(0)
	body_entered.connect(_on_body_entered)
	$CooldownTimer.timeout.connect(_on_cooldown_timeout)
	
	
	
func _on_background_color_changed(bkg_color: Enums.LightColor):
	$Sprite2D.visible = bkg_color != color
	
func _process(delta):
	if player == null:
		return
	var sqr_dist_to_player = global_position.distance_squared_to(player.position)
	if sqr_dist_to_player < purchase_distance.y * purchase_distance.y:
		print_debug(sqrt(sqr_dist_to_player)," ", purchase_distance.y," ", purchase_distance.x," ",turnaround_timer.time_left)
		if sqr_dist_to_player < purchase_distance.x * purchase_distance.x:
				print_debug("in minimum")
				turnaround_timer = get_tree().create_timer(turnaround_cooldown_duration)

		if turnaround_timer.time_left != 0: # no cooldown, chase
			print_debug("evade")
			var direction = sign(global_position.x - player.global_position.x)
			global_position.x += direction * speed * delta
			$Sprite2D.scale.x = direction * abs($Sprite2D.scale.x)			
		else: # cooldown, evade
			print_debug("chase")
			var direction = sign(player.global_position.x - global_position.x)

			global_position.x += direction * speed * delta
			$Sprite2D.scale.x = direction * abs($Sprite2D.scale.x)

		#if sqr_dist_to_player > purchase_distance.x * purchase_distance.x and turnaround_timer.time_left == 0:
			#var direction = sign(player.global_position.x - global_position.x)
			#global_position.x += direction * speed * delta
			##if $Sprite2D.scale.x * direction < 0:
			#$Sprite2D.scale.x = direction * abs($Sprite2D.scale.x)
		#else:
			#if turnaround_timer.time_left == 0:
				#turnaround_timer = get_tree().create_timer(turnaround_cooldown_duration)
			#var direction = sign(global_position.x - player.global_position.x)
			#global_position.x += direction * speed * delta
			#$Sprite2D.scale.x = direction * abs($Sprite2D.scale.x)
			
	if sqr_dist_to_player < attack_range*attack_range and not is_in_cooldown:
		_damage_player()
		is_in_cooldown = true
		$CooldownTimer.start()

func _damage_player():
	if player == null:
		return
	player.take_damage(damage)
	#print_debug("atk player")

func _on_cooldown_timeout():
	is_in_cooldown = false

func _on_body_entered(body):
	pass
	#_damage_player()
	

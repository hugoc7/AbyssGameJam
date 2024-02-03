@tool
extends Area2D

class_name EnemyBat

@export var color = Enums.LightColor.WHITE
@export var white_texture : Texture2D = null
@export var black_texture : Texture2D = null
@export var player : Node2D = null
const purchase_distance = Vector2(250,1200) # (min, max)
@export var speed : float = 50.0
const y_speed: float = 5
@export var damage : int = 10
@export var attack_range : float = 200

var is_in_cooldown = false

const turnaround_cooldown_duration : float = 5
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
		#print_debug(sqrt(sqr_dist_to_player)," ", purchase_distance.y," ", purchase_distance.x," ",turnaround_timer.time_left)
		if sqr_dist_to_player < purchase_distance.x * purchase_distance.x:
				turnaround_timer = get_tree().create_timer(turnaround_cooldown_duration)

		if turnaround_timer.time_left != 0: # no cooldown, chase
			var direction = sign(global_position.x - player.global_position.x)
			global_position.x += direction * speed * delta
			$Sprite2D.scale.x = direction * abs($Sprite2D.scale.x)			
		else: # cooldown, evade
			var direction = sign(player.global_position.x - global_position.x)

			global_position.x += direction * speed * delta
			$Sprite2D.scale.x = direction * abs($Sprite2D.scale.x)
		
		global_position.y += y_speed * delta * (abs(int(global_position.x) % 100 - 50)-25)
		
			
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
	

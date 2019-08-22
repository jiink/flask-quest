extends KinematicBody2D

var follow_distance = 23
var previous_position = Vector2(0.0, 0.0)
var motion
var direction = "down"

var in_water = false

onready var leader = get_node("../Player")

func _ready():
	set_process(false)
	yield(get_tree().create_timer(0.1), "timeout")
	set_process(true)

func _process(delta):
	previous_position = position
	position = leader.position_history[follow_distance]
	
	motion = Vector2(make_one(position.x - previous_position.x), make_one(position.y - previous_position.y))
	
	match motion:
		Vector2(0, -1):
			direction = "up"
		Vector2(1, -1):
			direction = "rightup"
		Vector2(1, 0):
			direction = "right"
		Vector2(1, 1):
			direction = "rightdown"
		Vector2(0, 1):
			direction = "down"
		Vector2(-1, 1):
			direction = "leftdown"
		Vector2(-1, 0):
			direction = "left"
		Vector2(-1, -1):
			direction = "leftup"
	
	$AnimatedSprite.animation = direction
	
	$AnimatedSprite.speed_scale = 1.3
	if motion.length() > 0:
		$AnimatedSprite.playing = true
	else:
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 0

	in_water = leader.in_water_history[follow_distance]
	set_in_water(in_water)

func set_in_water(setting):
	in_water = setting
	if setting:
		if has_node("InWaterEffect"):
			$InWaterEffect.visible = true
		else:
			var wf = load("res://Player/InWaterEffect.tscn").instance()
			add_child(wf)
			wf.get_node("Light2D").range_item_cull_mask = 2048
			$AnimatedSprite.light_mask = 2049
			
		$AnimatedSprite.offset.y = 4
	else:
		if has_node("InWaterEffect"):
			$InWaterEffect.visible = false
		$AnimatedSprite.offset.y = 0

func make_one(num):
	if num < 0:
		num = -1
	elif num > 0:
		num = 1
	return num
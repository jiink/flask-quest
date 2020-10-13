extends KinematicBody2D

var follow_distance = 5
var previous_position = Vector2(0.0, 0.0)
var motion
var direction = "down"

var in_water = false

#var t = 0

onready var leader = get_node("../Player")

func _ready():
	set_process(false)
	yield(get_tree().create_timer(0.1), "timeout")
	set_process(true)

func _process(delta):
#	previous_position = position
#	position = leader.position_history[follow_distance]
#	t += 1
	$FollowTween.interpolate_property(self, "position", null, leader.position_history[follow_distance], 0.1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)

	$FollowTween.start()
	
	motion = Vector2(make_one(position.x - previous_position.x), make_one(position.y - previous_position.y))
	
	match motion:
		Vector2(0, -1):
			direction = Direction.UP
		Vector2(1, -1):
			direction = Direction.RIGHTUP
		Vector2(1, 0):
			direction = Direction.RIGHT
		Vector2(1, 1):
			direction = Direction.RIGHTDOWN
		Vector2(0, 1):
			direction = Direction.DOWN
		Vector2(-1, 1):
			direction = Direction.LEFTDOWN
		Vector2(-1, 0):
			direction = Direction.LEFT
		Vector2(-1, -1):
			direction = Direction.LEFTUP
#	if t%20 > t%15 : print($AnimatedSprite.playing)
	$AnimatedSprite.animation = direction
	
	$AnimatedSprite.speed_scale = 1.3
#	if t%20 == 0:
	if motion.length() > 0:
		$AnimatedSprite.playing = true
	else:
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 0

	in_water = leader.in_water_history[follow_distance]
	set_in_water(in_water)
	
	previous_position = position

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

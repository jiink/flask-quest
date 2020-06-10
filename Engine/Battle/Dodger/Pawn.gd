extends Node2D

var player_mode = 1 # which player controls this pawn?

var rot =   0.0
var rot_v = 0.0

var rot_speed = 0.55
var max_rot_speed = 4.0
var rot_friction = .85

var left_action
var right_action

var shielded = false
var shield_time = 0.4
var shield_delay = 0.4

func _ready():
	set_player_mode(1)
	$ShieldTimer.connect("timeout", self, "shield_timer_timeout")
	
func move(delta):
	rot_v =  clamp(rot_v, -max_rot_speed, max_rot_speed)
	if Input.is_action_pressed(left_action):
		rot_v -= rot_speed * Input.get_action_strength(left_action)
	elif Input.is_action_pressed(right_action):
		rot_v += rot_speed * Input.get_action_strength(right_action)
	else:
		rot_v *= rot_friction 
	
	rot += rot_v*delta*60
	set_rotation_degrees(rot)
	
	if $ShieldDelay.is_stopped():
		if Input.is_action_just_pressed("confirm"):
			shielded = true
			$InstaShield.visible = true
			$ShieldTimer.start(shield_time)

func set_player_mode(p):
	match p:
		1:
			left_action = "left"
			right_action = "right"
		2:
			left_action = "left2"
			right_action = "right2"
		_:
			print("warning: pawn got its player mode set wrong, at %s" % p)

func shield_timer_timeout():
	shielded = false
	$InstaShield.visible = false
	$ShieldDelay.start(shield_delay)

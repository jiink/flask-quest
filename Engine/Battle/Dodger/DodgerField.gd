extends Node2D

var rot =   0.0
var rot_v = 0.0

var rot_speed = 30
var max_rot_speed = 3.0
var rot_friction = 42

func _process(delta):
	if visible:
		move_players(delta)
	

func move_players(delta):
	rot_v =  clamp(rot_v, -max_rot_speed, max_rot_speed)
	if Input.is_action_pressed("left"):
		rot_v -= rot_speed * delta
	elif Input.is_action_pressed("right"):
		rot_v += rot_speed * delta
	else:
		rot_v *= rot_friction * delta
	
	rot += rot_v
	$Dodgers.set_rotation_degrees(rot)
	
func run():
	pass
extends Node2D

var rot_green =   0.0
var rot_green_v = 0.0

var rot_orange =   180.0
var rot_orange_v = 0.0

var rot_speed = 30
var max_rot_speed = 3.0
var rot_friction = 42

func _process(delta):
	
	rot_green_v =  clamp(rot_green_v, -max_rot_speed, max_rot_speed)
	if Input.is_action_pressed("left"):
		rot_green_v -= rot_speed * delta
	elif Input.is_action_pressed("right"):
		rot_green_v += rot_speed * delta
	else:
		rot_green_v *= rot_friction * delta
		
	rot_orange_v = clamp(rot_orange_v, -max_rot_speed, max_rot_speed)
	if Input.is_action_pressed("a"):
		rot_orange_v -= rot_speed * delta
	elif Input.is_action_pressed("b"):
		rot_orange_v += rot_speed * delta
	else:
		rot_orange_v *= rot_friction * delta
	
	rot_green += rot_green_v
	rot_orange += rot_orange_v
	
	$GreenDodger.set_rotation_degrees(rot_green)
	$OrangeDodger.set_rotation_degrees(rot_orange)
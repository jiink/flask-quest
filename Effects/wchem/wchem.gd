extends Node2D

var delta_x = 0
var pre_x = 0
var accel = 0
var pre_delta_x = 0
var wobble = 0

var push = 0
export(float) var push_speed = 0.1

onready var liq_mat = $Liquid.material


func _physics_process(delta):
	pre_x = position.x
	pre_delta_x = delta_x
	
	if Input.is_action_pressed("left"):
		push -= push_speed
	elif Input.is_action_pressed("right"):
		push += push_speed
	else:
		push *= 0.8
	position.x += push

	delta_x = position.x - pre_x
	accel = -(delta_x - pre_delta_x)
	wobble = liq_mat.get_shader_param("wobble") + accel * 0.2
	wobble *= 0.9
	liq_mat.set_shader_param("wobble", wobble)
	
	$Label.set_text("accel: %s\nwobble: %s" % [accel, wobble])

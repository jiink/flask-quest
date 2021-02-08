extends Node2D


onready var last_position = position
onready var particles = $RainParticles
onready var camera = global.get_camera()
var delta_pos = Vector2(0, 0)
var moving = false
var last_moving = true # was the rain moving in the last tick?
var moving_threshold = 1


func _tick():
	delta_pos = camera.position - last_position
	var delta_pos_length = delta_pos.length()
	
	moving = delta_pos.length() > moving_threshold
	if moving:
#		rotation = delta_pos * 0.2
		particles.process_material.angle = (-delta_pos.x)
		
	else:
		particles.process_material.angle = 0
	last_position = camera.position

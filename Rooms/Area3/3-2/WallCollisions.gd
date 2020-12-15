extends KinematicBody2D

onready var player = get_node("../PhysicsPlayer")

func _process(delta):
	position.y = player.position.y

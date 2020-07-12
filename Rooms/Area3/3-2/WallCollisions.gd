extends KinematicBody2D

onready var player = get_node("../Player")

func _process(delta):
	position.y = player.position.y

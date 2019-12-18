extends Node2D

func _ready():
	global.get_player().frozen = true

func _process(delta):
	if Input.is_action_just_released("cancel"):
		global.get_player().frozen = false
		queue_free()
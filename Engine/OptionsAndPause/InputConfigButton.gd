extends Node2D

var listening = false

func _ready():
	pass

func _process(delta):
	if listening:
		pass

func on_wait_for_input():
	listening = true
	print("...button now listening...")
extends "res://Rooms/TemplateRoom.gd"

var kicked_out_lobby

var SAVE_KEY = "4-1_"

var ready_to_ask_for_keycard = false

onready var orange = $YSort/Orange
onready var green = $YSort/Player


func save(save_game):
	save_game.data[SAVE_KEY + "kicked_out_lobby"] = kicked_out_lobby
	
func load(save_game):
	kicked_out_lobby = save_game.data[SAVE_KEY + "kicked_out_lobby"]

func _on_OnArea_body_entered(body):
	pass # Replace with function body.

func forced_out_entrance():
	kicked_out_lobby = true
	green.controlled_by = green.PERSON
	orange.controlled_by = orange.PERSON
	$ForcedOutEvent.play("default")

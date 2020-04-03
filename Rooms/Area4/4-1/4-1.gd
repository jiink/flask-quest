extends "res://Rooms/TemplateRoom.gd"

var been_in_malus = true

var SAVE_KEY = "4-1_"

var ready_to_ask_for_keycard = false

func save(save_game):
	save_game.data[SAVE_KEY + "been_in_malus"] = been_in_malus
	
func load(save_game):
	pass




func _on_OnArea_body_entered(body):
	pass # Replace with function body.

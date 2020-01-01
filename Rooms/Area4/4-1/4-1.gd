extends "res://Rooms/TemplateRoom.gd"

var been_in_malus = true

var SAVE_KEY = "4-1_"

func save(save_game):
	save_game.data[SAVE_KEY + "been_in_malus"] = been_in_malus
#	print("put %s in save thing" % been_in_malus)
	
func load(save_game):
#	been_in_malus = save_game.data[SAVE_KEY + "been_in_malus"]
#	print("put %s in save thing" % been_in_malus)
	pass



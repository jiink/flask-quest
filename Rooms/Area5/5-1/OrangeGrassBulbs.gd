extends Node2D

var SAVE_KEY = "5-1_grassbulb_"
var harvested = false
onready var dubble = get_node("../Dubble")

func save(save_game):
	save_game.data[SAVE_KEY + "harvested"] = harvested

func load(save_game):
	harvested = save_game.data[SAVE_KEY + "harvested"]
	setup(harvested)
	
func setup(state):
	if state:
		$Sprite.frame = 1
	else:
		$Sprite.frame = 0

func interact():
	if (dubble.current_mission > 0) and (not harvested):
		ItemManager.give_item("orange_grassbulbs_item")
		$Sprite.frame = 1
		harvested = true
	elif harvested:
		DiagHelper.start_talk(self)

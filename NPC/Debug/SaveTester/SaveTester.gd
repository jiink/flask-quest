extends Node2D

var state = "red"

onready var SAVE_KEY = "test_" + name

func interact():
	if state == "red":
		state = "blue"
		$ColorRect.color = Color(0, 0, 200)
	else:
		state = "red"
		$ColorRect.color = Color(200, 0, 0)
	
	print("savetester state: " + state)

func save(save_game):
	save_game.data[SAVE_KEY] = state
	
func load(save_game):
	state = save_game.data[SAVE_KEY]
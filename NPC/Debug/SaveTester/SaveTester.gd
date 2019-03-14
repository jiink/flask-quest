extends Node2D

var state = "red"

onready var SAVE_KEY = "test_" + name

func interact():
	if state == "red":
		state = "blue"
	else:
		state = "red"
	update_colors()
	#print("savetester state: " + state)

func update_colors():
	if state == "red":
		$ColorRect.color = Color(200, 0, 0)
	else:
		$ColorRect.color = Color(0, 0, 200)

func save(save_game):
	save_game.data[SAVE_KEY] = state
	update_colors()
	
func load(save_game):
	print("current: %s, new: %s" % [state, save_game.data[SAVE_KEY]])
	state = save_game.data[SAVE_KEY]
	print("after loading: %s" % state)
	update_colors()
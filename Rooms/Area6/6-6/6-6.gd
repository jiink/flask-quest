extends "res://Rooms/TemplateRoom.gd"


const SAVE_KEY = "6-1_"

var current_dinner_state
var current_story_state
var green
var orange
var ribbit

func save(save_game):
	save_game.data[SAVE_KEY + "dinner_state"] = current_dinner_state
	save_game.data[SAVE_KEY + "story_state"] = current_story_state

func load(save_game):
	var receptionist = $YSort/Receptionist
	var purple = $YSort/Purple
	green = global.get_player(1)
	orange = global.get_player(2)
	ribbit = global.get_player(3)
	
	current_dinner_state = save_game.data[SAVE_KEY + "dinner_state"]
	current_story_state = save_game.data[SAVE_KEY + "story_state"]
	
	if current_story_state == 5:
		receptionist.main_dialogue = "PurpleDinner"
	elif (current_story_state != 5) and (current_dinner_state != 2):
		receptionist.main_dialogue = "General"
		purple.queue_free()
	elif current_dinner_state == 2:
		receptionist.main_dialogue = "HopeEnjoy"
		green.controlled_by = green.EXTERNAL
		orange.controlled_by = orange.EXTERNAL
		ribbit.controlled_by = ribbit.EXTERNAL
		
		purple.lead_back()
	
		

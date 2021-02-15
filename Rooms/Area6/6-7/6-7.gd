extends Node

const SAVE_KEY = "6-1_"
const PURPLE_MISSION_SCENE = preload("res://NPC/Purple/PurpleMission.tscn")

var current_story_state

var green
var orange
var ribbit

func save(save_game):
	save_game.data[SAVE_KEY + "story_state"] = current_story_state

func load(save_game):
	green = global.get_player(1)
	orange = global.get_player(2)
	ribbit = global.get_player(3)

	current_story_state = save_game.data[SAVE_KEY + "story_state"]
	setup()
	
func setup():
	if current_story_state >= 8: # and current_story_state <= 10:
			var purple_mission = PURPLE_MISSION_SCENE.instance()
			get_node("YSort").add_child(purple_mission)
			purple_mission.position = Vector2(121,75)
			var save_game = GameSaver.active_save_slot_id
			purple_mission.current_story_state = current_story_state

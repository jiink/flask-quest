extends "res://Rooms/TemplateRoom.gd"

enum TimesOfDay { MORNING, NOON, EVENING, NIGHT }
enum StoryState { 
	PRE_KIDNAP,
	GET_HOTEL_ROOM, 
	MURK_MONSTER,
	VEHICLE,
	PUSHED_VEHICLE,
	DINNER,
	SLEEP_HOTEL,
	PURPLE_POSTERS,
	PURPLE_POTION,
	FIXED_TRUCK
}

const COLOR_MORNING = Color(1, 0.901961, 0.643137)
const COLOR_NOON = Color(1, 1, 1)
const COLOR_EVENING = Color(1, 0.635294, 0.635294)
const COLOR_NIGHT = Color(0, 0, 0)

var time_of_day
var poppy_story_state

func save(save_game):
	save_game.data["6-1_story_state"] = poppy_story_state

func load(save_game):
	time_of_day = save_game.data["6-1_time_of_day"]
	poppy_story_state = save_game.data["6-1_story_state"]
	set_time()
	
func set_time():
	match time_of_day:
		TimesOfDay.MORNING:
			set_daylight_color(COLOR_MORNING)
		TimesOfDay.NOON:
			set_daylight_color(COLOR_NOON)
		TimesOfDay.EVENING:
			set_daylight_color(COLOR_EVENING)
		TimesOfDay.NIGHT:
			set_daylight_color(COLOR_NIGHT)
			
func set_daylight_color(color_of_time):
	for daylights in get_tree().get_nodes_in_group("daylight"):
		daylights.color = color_of_time
	var daylight_tilemap = get_tree().get_current_scene().get_node("Tilemaps/6-3/Daylight")
	daylight_tilemap.modulate = color_of_time

extends "res://Rooms/TemplateRoom.gd"

const SAVE_KEY = "6-1_"

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

enum TimesOfDay { MORNING, NOON, EVENING, NIGHT }

const COLOR_MORNING = Color(1, 0.901961, 0.643137)
const COLOR_NOON = Color(1, 1, 1)
const COLOR_EVENING = Color(1, 0.635294, 0.635294)
const COLOR_NIGHT = Color(0.313726, 0.231373, 0.317647)

var time_of_day
var color_of_time
var time_tween
var modulate
var current_story_state = StoryState.PRE_KIDNAP

func save(save_game):
	save_game.data[SAVE_KEY + "time_of_day"] = time_of_day
	save_game.data[SAVE_KEY + "story_state"] = current_story_state

func load(save_game):
	modulate = $CanvasModulate
	time_tween = $TimeTween
	time_of_day = save_game.data[SAVE_KEY + "time_of_day"]
	current_story_state = save_game.data[SAVE_KEY + "story_state"]
	setup()
	
func setup():
	var mm_stand = get_node("YSort/monster_stand")
	
	if current_story_state != StoryState.PRE_KIDNAP:
		var bus = get_node("YSort/Bus")
		var kidnap_event = get_node("KidnapEvent")
		if (bus != null) and (kidnap_event != null):
			bus.queue_free()
			kidnap_event.queue_free()
	get_node("YSort/CallBellSystem7").talkative = false
		
	match current_story_state:
		StoryState.PRE_KIDNAP:
			mm_stand.change_stand_sprite(0)
			global.get_player(3).queue_free()
		StoryState.GET_HOTEL_ROOM:
			get_node("YSort/CallBellSystem7").talkative = true
			mm_stand.change_stand_sprite(0)
		StoryState.MURK_MONSTER:
			mm_stand.change_stand_sprite(0)
		StoryState.VEHICLE:
			mm_stand.change_stand_sprite(1)
			
	mm_stand.state = current_story_state
	
	set_time(time_of_day, false)
	
	
func set_time(time, fade):
	time_of_day = time
	match time_of_day:
		TimesOfDay.MORNING:
			color_of_time = COLOR_MORNING
			if not fade:
				modulate.color = color_of_time
			else:
				tween_time()
		TimesOfDay.NOON:
			color_of_time = COLOR_NOON
			if not fade:
				modulate.color = color_of_time
			else:
				tween_time()
		TimesOfDay.EVENING:
			color_of_time = COLOR_EVENING
			if not fade:
				modulate.color = color_of_time
			else:
				tween_time()
		TimesOfDay.NIGHT:
			color_of_time = COLOR_NIGHT
			if not fade:
				modulate.color = color_of_time
			else:
				tween_time()

func tween_time():
	time_tween.interpolate_property( modulate, "color",
	null, color_of_time, 10.0, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR )

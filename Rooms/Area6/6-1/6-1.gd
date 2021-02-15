extends "res://Rooms/TemplateRoom.gd"

const SAVE_KEY = "6-1_"

const CAR_ROOF_SCENE = preload("res://Rooms/Area6/6-1/CarRoof.tscn")
const CAR_GROUND_SCENE = preload("res://Rooms/Area6/6-1/CarGround.tscn")
#const PURPLE_SCENE = preload("res://NPC/Purple/Purple.tscn")
const PURPLE_MISSION_SCENE = preload("res://NPC/Purple/PurpleMission.tscn")

enum StoryState { 
	PRE_KIDNAP, #0
	GET_HOTEL_ROOM, #1
	MURK_MONSTER, #2
	VEHICLE, #3
	PUSHED_VEHICLE, #4
	DINNER, #5
	SLEEP_HOTEL, #6
	VISIT_PURPLE, #7
	PURPLE_LETTERS, #8
	PURPLE_LETTERS_REMINDER, #9
	PURPLE_POSTERS, #10
	PURPLE_POSTERS_REMINDER, #11
	PURPLE_GLASSES, #12
	PURPLE_POTION, #13
	FIXED_TRUCK #14
}

enum DinnerState {
	FALSE,
	TRUE,
	POST
}

enum MailBox { ONE, TWO, THREE, FIVE, SIX}

var mail_boxes = [ false, false, false, false, false ]

var current_dinner_state

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
var background_layers

func save(save_game):
	save_game.data[SAVE_KEY + "time_of_day"] = time_of_day
	save_game.data[SAVE_KEY + "story_state"] = current_story_state
	save_game.data[SAVE_KEY + "dinner_state"] = current_dinner_state
	save_game.data[SAVE_KEY + "mail_boxes"] = mail_boxes

func load(save_game):
	background_layers = get_tree().get_nodes_in_group("background")
	modulate = $CanvasModulate
	time_tween = $TimeTween
	time_of_day = save_game.data[SAVE_KEY + "time_of_day"]
	current_story_state = save_game.data[SAVE_KEY + "story_state"]
	current_dinner_state = save_game.data[SAVE_KEY + "dinner_state"]
	mail_boxes = save_game.data[SAVE_KEY + "mail_boxes"]
	setup()
	
func setup():
	var green = global.get_player(1)
	var orange = global.get_player(2)
	var ribbit = global.get_player(3)
	var purple = get_node("YSort/Purple")
	
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
			set_time(TimesOfDay.MORNING, false)
			mm_stand.change_stand_sprite(0)
			global.get_player(3).queue_free()
			
		StoryState.GET_HOTEL_ROOM:
			set_time(TimesOfDay.MORNING, false)
			get_node("YSort/CallBellSystem7").talkative = true
			mm_stand.change_stand_sprite(0)
			
		StoryState.MURK_MONSTER:
			set_time(TimesOfDay.MORNING, false)
			set_time(TimesOfDay.NOON, true)
			mm_stand.change_stand_sprite(0)
			
		StoryState.VEHICLE:
			mm_stand.change_stand_sprite(1)
			set_time(TimesOfDay.NIGHT, false)
			var car_roof = CAR_ROOF_SCENE.instance()
			get_node("YSort").add_child(car_roof)
			car_roof.position = Vector2(2505, -1658)
			
		StoryState.PUSHED_VEHICLE:
			set_time(TimesOfDay.NIGHT, false)
			mm_stand.change_stand_sprite(1)
			var car_ground = CAR_GROUND_SCENE.instance()
			get_node("YSort").add_child(car_ground)
			car_ground.position = Vector2(646, -614)
			
		StoryState.DINNER:
			set_time(TimesOfDay.NIGHT, false)
			mm_stand.change_stand_sprite(1)
			var car_ground = CAR_GROUND_SCENE.instance()
			get_node("YSort").add_child(car_ground)
			car_ground.position = Vector2(646, -614)
			
		StoryState.SLEEP_HOTEL:
			set_time(TimesOfDay.NIGHT, false)
			mm_stand.change_stand_sprite(1)
			DiagHelper.start_talk(ribbit, "RequestSleep")
			
		StoryState.VISIT_PURPLE:
			set_time(TimesOfDay.MORNING, false)
			mm_stand.change_stand_sprite(1)
			var car_ground = CAR_GROUND_SCENE.instance()
			get_node("YSort").add_child(car_ground)
			car_ground.position = Vector2(574, -1141)
			
			var purple_mission = PURPLE_MISSION_SCENE.instance()
			get_node("YSort").add_child(purple_mission)
			purple_mission.position = Vector2(650,-1168)
			
		StoryState.PURPLE_LETTERS:
			set_time(TimesOfDay.MORNING, false)
			mm_stand.change_stand_sprite(1)
			var car_ground = CAR_GROUND_SCENE.instance()
			get_node("YSort").add_child(car_ground)
			car_ground.position = Vector2(574, -1141)
			
		StoryState.PURPLE_POSTERS:
			set_time(TimesOfDay.MORNING, false)
			mm_stand.change_stand_sprite(1)
			var car_ground = CAR_GROUND_SCENE.instance()
			get_node("YSort").add_child(car_ground)
			car_ground.position = Vector2(574, -1141)
			
	mm_stand.state = current_story_state
	
	set_time(time_of_day, false)
	
	if current_dinner_state == 1:
		
		green.controlled_by = green.EXTERNAL
		orange.controlled_by = orange.EXTERNAL
		ribbit.controlled_by = ribbit.EXTERNAL
		purple.initiate_dinner()
	else:
		purple.queue_free()
	
	
	
func set_time(time, fade):
	time_of_day = time
	match time_of_day:
		TimesOfDay.MORNING:
			color_of_time = COLOR_MORNING
			set_night_lights(false)
			if not fade:
				modulate.color = color_of_time
				for layer in background_layers:
					layer.modulate = color_of_time
			else:
				tween_time()
		TimesOfDay.NOON:
			color_of_time = COLOR_NOON
			set_night_lights(false)
			if not fade:
				modulate.color = color_of_time
				for layer in background_layers:
					layer.modulate = color_of_time
			else:
				tween_time()
		TimesOfDay.EVENING:
			color_of_time = COLOR_EVENING
			set_night_lights(false)
			if not fade:
				modulate.color = color_of_time
				for layer in background_layers:
					layer.modulate = color_of_time
			else:
				tween_time()
		TimesOfDay.NIGHT:
			color_of_time = COLOR_NIGHT
			set_night_lights(true)
			if not fade:
				modulate.color = color_of_time
				for layer in background_layers:
					layer.modulate = color_of_time
			else:
				tween_time()

func tween_time():
	time_tween.interpolate_property( modulate, "color",
	null, color_of_time, 10.0, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR )
	for layer in background_layers:
		time_tween.interpolate_property( layer, "modulate",
		null, color_of_time, 10.0, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR )
	time_tween.start()

func vehicle_pushed():
	var car_ground = CAR_GROUND_SCENE.instance()
	get_node("YSort").add_child(car_ground)
	car_ground.position = Vector2(646, -547)

func set_night_lights(set):
	for night_light in get_tree().get_nodes_in_group("night_lights"):
		night_light.enabled = set
	for night_emissive in get_tree().get_nodes_in_group("night_emissive"):
		night_emissive.visible = set

extends "res://Rooms/TemplateRoom.gd"

enum { DAWN, DAY, DUSK, NIGHT }

var SAVE_KEY = "5-1_"

var time_of_day = 0
var dubble_quest_status = 0
var dubble_intro_event_occured = false

var color_dawn = Color(0xc2975bff)
var color_day = Color(0xffffffff)
var color_dusk = Color(0x92564bff)
var color_night = Color(0x2d3158ff)

var modulate_color

func save(save_game):
	save_game.data[SAVE_KEY + "time_of_day"] = time_of_day

	
func load(save_game):
	time_of_day = save_game.data[SAVE_KEY + "time_of_day"]
	update_time_of_day(time_of_day)

func update_time_of_day(state):
	var modulate_color_animator = get_node("CanvasModulate/AnimationPlayer")
	match state:
		DAWN:
			modulate_color_animator.play("dawn")
		DAY:
			modulate_color_animator.play("noon")
		DUSK:
			modulate_color_animator.play("dusk")
		NIGHT:
			modulate_color_animator.play("night")
#		_:
#			modulate_color = Color(0xff0000ff)
#	$CanvasModulate.color = modulate_color
#	$"Background/ParallaxBackground/ParallaxLayer/outside_forest".modulate = modulate_color
#	print("time of day should be %s" % modulate_color)

func remove_dubble_intro_event(state):
	if state:
		$DubbleIntroEvent.queue_free()
		
func set_night_lights(state):
	if state:
		for night_lights in get_tree().get_nodes_in_group("night_lights"):
			night_lights.visible = true
	else:
		for night_lights in get_tree().get_nodes_in_group("night_lights"):
			night_lights.visible = false

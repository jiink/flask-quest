extends "res://Rooms/TemplateRoom.gd"

enum TimesOfDay { DAWN, DAY, DUSK, NIGHT }

var SAVE_KEY = "5-1_"

var time_of_day = 0
#var dubble_quest_status = 0
#var dubble_intro_event_occured = false
var supertunnel_entered = false
var in_escape_sequence = false

const COLOR_DAWN = Color(0xc2975bff)
var COLOR_DAY = Color(0xffffffff)
var COLOR_DUSK = Color(0x92564bff)
var COLOR_NIGHT = Color(0x2d3158ff)

var modulate_color

func save(save_game):
	save_game.data[SAVE_KEY + "time_of_day"] = time_of_day
	
func load(save_game):
	time_of_day = save_game.data[SAVE_KEY + "time_of_day"]
	in_escape_sequence = save_game.data["5-2_bomb_planted"]
	update_time_of_day(time_of_day)
	setup_escape(in_escape_sequence)

func update_time_of_day(state):
	match state:
		TimesOfDay.DAWN:
			modulate_color = COLOR_DAWN
			set_night_lights(true)
		TimesOfDay.DAY:
			modulate_color = COLOR_DAY
			set_night_lights(false)
		TimesOfDay.DUSK:
			modulate_color = COLOR_DUSK
			set_night_lights(true)
		TimesOfDay.NIGHT:
			modulate_color = COLOR_NIGHT
			set_night_lights(true)
#		_:
#			modulate_color = Color(0xff0000ff)
	$CanvasModulate.color = modulate_color
	$"Background/ParallaxBackground/ParallaxLayer/outside_forest".modulate = modulate_color
#	print("time of day should be %s" % modulate_color)

func fade_time_of_day(state):
	var modulate_color_animator = get_node("CanvasModulate/AnimationPlayer")
	match state:
		TimesOfDay.DAWN:
			modulate_color_animator.play("dawn")
			time_of_day = 0
		TimesOfDay.DAY:
			modulate_color_animator.play("noon")
			time_of_day = 1
		TimesOfDay.DUSK:
			modulate_color_animator.play("dusk")
			time_of_day = 2
		TimesOfDay.NIGHT:
			modulate_color_animator.play("night")
			time_of_day = 3
			
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
			
func setup_escape(state): #Sets up the scene for after Green and Orange plant the bomb
	if state:
#		level_music = "res://Music/goodvibes.ogg"
		var escape_music = preload("res://Music/goodvibes.ogg")
		MusicManager.change_music(escape_music, true, 0) #Replace goodvibes
		$"EscapePortal/EscapePortalCollision".set_deferred("disabled", false)
		for glasstown_prisoner in get_tree().get_nodes_in_group("glasstown_prisoners"):
			glasstown_prisoner.queue_free()

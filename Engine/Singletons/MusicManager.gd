extends Node

var current_level_music
var current_battle_music

var level_music_pos_marker = 0.0

var music_type = "level"
var previous_type = "level"

var transition_length = 0.7

var aftermath_length = 0.2

onready var focus = $MainPlayer

func _ready():
	set_process(false)
	yield(get_tree().create_timer(0.1), "timeout")
#	update_music("level")
	
	current_level_music = get_tree().get_current_scene().get("level_music")
	focus.set_stream(current_level_music)
	

	focus.play()
	set_process(true)
	

func _process(delta):
	if focus.get_playback_position() >= focus.stream.get_length() - aftermath_length:
		if focus == $MainPlayer:
			focus = $AssistantPlayer
		elif focus == $AssistantPlayer:
			focus = $MainPlayer
		else:
			print("focus is %s" % focus)
		
		focus.set_stream(current_level_music)
		focus.play()
	
#	if Input.is_action_just_pressed("y"):
#		fade_music_out("level")

func update_music(type):
#	if get_tree().get_current_scene().get("level_music") and get_tree().get_current_scene().get("battle_music"):
#		current_level_music = get_tree().get_current_scene().get("level_music")
#		current_battle_music = get_tree().get_current_scene().get("battle_music")
#
#	if previous_type == "level" and typeof(type) == TYPE_STRING:
#		if type != "level":
#			level_music_pos_marker = focus.get_playback_position()
#
#	match type:
#		"level":
#			set_stream(current_level_music)
#
#		"battle":
#			set_stream(current_battle_music)
#		"none":
#			set_stream(null)
#		_:
#			set_stream(type) # for custom music
##			print("did you call update_music() wrong?")
#			type = "custom"
#
#	if get_stream() != null:
#		if type == "level":
#			play(level_music_pos_marker)
#		else:
#			play()
#		$AnimationPlayer.play("fade_in")
#	else:
#		print("warning, music is null")
#
#	previous_type = type
	pass
	
func fade_music_out(type):
	if type == "level":
		$Tween.interpolate_property($MainPlayer, "volume_db",
			null, 0.0,
			transition_length, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	
	
	$Tween.interpolate_property($AssistantPlayer, "volume_db",
			null, 0.0,
			transition_length, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
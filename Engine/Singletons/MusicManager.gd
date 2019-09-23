extends Node

var current_level_music
var current_battle_music

var level_music_pos_marker = 0.0

var music_type = "level"
var previous_type = "level"

var transition_length = 0.7

var aftermath_length = 0.2

onready var focus = $MainPlayer
var assistant_mode = false

var focus_prefix
var focus_suffix


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
		assistant_mode = not assistant_mode
		focus_prefix = "Battle" if music_type == "battle" else "Main"
		focus_suffix = "Assistant" if assistant_mode else ""
		focus = get_node(focus_prefix+"Player"+focus_suffix)
		
		focus.set_stream(current_level_music)
		focus.play()
	
#	if Input.is_action_just_pressed("y"):
#		fade_music_out("level")

func update_music(type):
	if get_tree().get_current_scene().get("level_music") and get_tree().get_current_scene().get("battle_music"):
		current_level_music = get_tree().get_current_scene().get("level_music")
		current_battle_music = get_tree().get_current_scene().get("battle_music")
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
	
func fade_music(type, mode):
	var target_vol = 0.0 if mode else -80.0
	var target_players = [get_node("BattlePlayer"), get_node("BattlePlayerAssistant")] if type == "battle" else [get_node("MainPlayer"), get_node("MainPlayerAssistant")]
	
	print("going to fade %s music to %s" % [type, target_vol])
	
	if mode == true:
		if target_players[1 if assistant_mode else 0].playing == false:
			target_players[1 if assistant_mode else 0].playing = true
		
	for i in range(2):
	
		$Tween.interpolate_property(target_players[i], "volume_db",
				null, target_vol,
				transition_length, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)

	
	$Tween.start()
	if mode == false:
		yield($Tween, "tween_completed")
		print("tween completed")
		for i in range(2): target_players[i].playing = false
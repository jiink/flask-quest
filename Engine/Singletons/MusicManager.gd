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
	set_main_streams(current_level_music)
	
	

#	focus.play()
	play_focus()
	set_process(true)
	
func _process(delta):
	if focus.get_playback_position() >= focus.stream.get_length() - aftermath_length:

		assistant_mode = not assistant_mode

		play_focus()


func get_status():
	print("-------musicmanager status--------")
	print("focus: %s" % focus.name)
	print("MainPlayer: %s" % $MainPlayer.get_playback_position())
	print("MainPlayerAssistant: %s" % $MainPlayerAssistant.get_playback_position())
	print("BattlePlayer: %s" % $BattlePlayer.get_playback_position())
	print("BattlePlayerAssistant: %s" % $BattlePlayerAssistant.get_playback_position())

func play_focus(from_where = 0.0):
	
	focus_prefix = "Battle" if music_type == "battle" else "Main"
	focus_suffix = "Assistant" if assistant_mode else ""
	focus = get_node(focus_prefix+"Player"+focus_suffix)
	
	focus.set_stream(current_battle_music if music_type == "battle" else current_level_music)
	
	print("Now playing %s from %s seconds" % [music_type, from_where])
	focus.play(from_where)
	
	
	
func update_music(type):
	music_type = type
	if get_tree().get_current_scene().get("level_music") and get_tree().get_current_scene().get("battle_music"):
		current_level_music = get_tree().get_current_scene().get("level_music")
		current_battle_music = get_tree().get_current_scene().get("battle_music")

	if previous_type == "level" and typeof(type) == TYPE_STRING:
		if type != "level":
			level_music_pos_marker = focus.get_playback_position()
#
	match type:
		"level":
			
			set_main_streams(current_level_music)
			fade_music("level", true)
			fade_music("battle", false)

		"battle":
			set_battle_streams(current_battle_music)
			fade_music("level", false)
			fade_music("battle", true)
			
		"none":
			set_battle_streams(null)
			set_main_streams(null)
			fade_music("level", false)
			fade_music("battle", false)
		_:
			set_main_streams(type) # for custom music
#			print("did you call update_music() wrong?")
			type = "custom"
#
#	if get_stream() != null:
#	if type == "level":
	play_focus(level_music_pos_marker)
#	else:
#		play()
#	$AnimationPlayer.play("fade_in")
#	else:
#		print("warning, music is null")
#
	previous_type = type
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

func set_main_streams(stream_in):
	$MainPlayer.set_stream(stream_in)
	$MainPlayerAssistant.set_stream(stream_in)

func set_battle_streams(stream_in):
	$BattlePlayer.set_stream(stream_in)
	$BattlePlayerAssistant.set_stream(stream_in)
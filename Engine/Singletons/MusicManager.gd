extends Node

var current_level_music
var current_battle_music
var current_custom_battle_music

var music_pos_marker = 0.0

var music_type = "level"
var previous_type = "level"

var transition_length = 1.0

var aftermath_length = 0.2
#13.5 for goodvibes # 0.2 for test

onready var focus = $MainPlayer
var assistant_mode = false

var focus_prefix
var focus_suffix

var aftermath_lengths = {
	"labs-2" : 1.50,
	"labs" : 0.05,
	"goodvibes" : 13.517,
	"cannedcranium": 1.332,
	"maloffice": 3.996,
	"lanetta" : 1.869,
	"sewers" : 0.08,
	"odd": 0.0
}

func _ready():
	
	set_process(false)
	yield(get_tree().create_timer(0.1), "timeout")
#	update_music("level")
	
	current_level_music = get_tree().get_current_scene().get("level_music")
	set_main_streams(current_level_music)
	
	

#	focus.play()
	play_focus()
	aftermath_length = get_track_aftermath_length(current_level_music.get_path())
	set_process(true)
	
func _process(delta):
	if focus.get_playback_position() >= focus.stream.get_length() - aftermath_length:

		assistant_mode = not assistant_mode

		play_focus()
	
	if Input.is_action_pressed("y"):
		focus.seek(focus.get_playback_position()+1.0)


func play_focus(from_where = 0.0):
	
	focus_prefix = "Battle" if (music_type == "battle" or music_type == "custom") else "Main"
	focus_suffix = "Assistant" if assistant_mode else ""
	focus = get_node(focus_prefix+"Player"+focus_suffix)
	
	if music_type == "battle":
		focus.set_stream(current_battle_music)
		aftermath_length = get_track_aftermath_length(current_battle_music.get_path())
	elif music_type == "level":
		focus.set_stream(current_level_music)
		aftermath_length = get_track_aftermath_length(current_level_music.get_path())
	elif music_type == "custom":
		focus.set_stream(current_custom_battle_music)
		aftermath_length = get_track_aftermath_length(current_custom_battle_music.get_path())
	else:
		print("trouble in play_focus, music_type = %s" % music_type)
		
	print("Now playing %s from %s seconds" % [music_type, from_where])
	focus.play(from_where)
	
	
	
func update_music(type):
	if (typeof(type) == TYPE_STRING):
		music_type = type
	else:
		music_type = "custom"
		
	if get_tree().get_current_scene().get("level_music") and get_tree().get_current_scene().get("battle_music"):
		current_level_music = get_tree().get_current_scene().get("level_music")
		current_battle_music = get_tree().get_current_scene().get("battle_music")

#	if previous_type == "level" and typeof(type) == TYPE_STRING:
#		if type != "level":
#			music_pos_marker = focus.get_playback_position()
#
	if (typeof(type) == TYPE_STRING) and (previous_type != type):
		music_pos_marker = focus.get_playback_position()
	
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
			current_custom_battle_music = type
			set_battle_streams(current_custom_battle_music) # for custom music
#			print("did you call update_music() wrong?")
			fade_music("level", false)
			fade_music("battle", true)
			type = "custom"
			
	# change aftermath_length
	aftermath_length = get_track_aftermath_length(focus.get_stream().get_path())

#
#	if get_stream() != null:
#	if type == "level":
	play_focus(music_pos_marker)
#	else:
#		play()
#	$AnimationPlayer.play("fade_in")
#	else:
#		print("warning, music is null")
#
	previous_type = type
	pass
	
func fade_music(type, mode):
	var target_vol = 0.0 if mode else -36.0
	var target_players = [get_node("BattlePlayer"), get_node("BattlePlayerAssistant")] if type == "battle" else [get_node("MainPlayer"), get_node("MainPlayerAssistant")]
	
	print("going to fade %s music to %s" % [type, target_vol])
	
	if mode == true:
		if target_players[1 if assistant_mode else 0].playing == false:
			target_players[1 if assistant_mode else 0].playing = true
		
	for i in range(2):
	
		$Tween.interpolate_property(target_players[i], "volume_db",
				null, target_vol,
				transition_length, Tween.TRANS_QUAD, Tween.TRANS_LINEAR)

	
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

func get_track_aftermath_length(path_name):
	for key in aftermath_lengths:
		if path_name.find(key) > -1:
			return aftermath_lengths[key]
	print("couldn't get aftermath length!")
	return 0.0
	
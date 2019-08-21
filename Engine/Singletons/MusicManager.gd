extends AudioStreamPlayer

var current_level_music
var current_battle_music

var level_music_pos_marker = 0.0
var previous_type = "level"

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	update_music("level")
	play()
	
func update_music(type):
	if get_tree().get_current_scene().get("level_music") and get_tree().get_current_scene().get("battle_music"):
		current_level_music = get_tree().get_current_scene().get("level_music")
		current_battle_music = get_tree().get_current_scene().get("battle_music")
	
	if previous_type == "level" and type != "level":
		level_music_pos_marker = get_playback_position()
	
	match type:
		"level":
			set_stream(current_level_music)
		"battle":
			set_stream(current_battle_music)
		_:
			print("did you call update_music() wrong?")
			
	if get_stream() != null:
		if type == "level":
			play(level_music_pos_marker)
		else:
			play()
		$AnimationPlayer.play("fade_in")
	else:
		print("warning, music is null")
	
	previous_type = type
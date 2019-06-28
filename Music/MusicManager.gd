extends AudioStreamPlayer

var current_level_music
var current_battle_music

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	update_music("level")
	play()
	
func update_music(type):
	if get_tree().get_current_scene().get("level_music") and get_tree().get_current_scene().get("battle_music"):
		current_level_music = get_tree().get_current_scene().get("level_music")
		current_battle_music = get_tree().get_current_scene().get("battle_music")
	match type:
		"level":
			set_stream(current_level_music)
		"battle":
			set_stream(current_battle_music)
		_:
			print("did you call update_music() wrong?")
	if get_stream() == null:
		print("warning, music is null")
	else:
		play()
		
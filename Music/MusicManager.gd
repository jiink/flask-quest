extends AudioStreamPlayer

var current_level_music
var current_battle_music

func _ready():
	update_music("level")
	play()
	
func update_music(type):
	current_level_music = get_tree().get_current_scene().level_music
	current_battle_music = get_tree().get_current_scene().battle_music
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
		
extends "res://Rooms/TemplateRoom.gd"


func _ready():
	MusicManager.change_music(null, true, 0)
	if AudioServer.is_bus_mute(1) == false:
		AudioServer.set_bus_mute(1, true)
		yield(get_tree().create_timer(20), "timeout")
		AudioServer.set_bus_mute(1, false)
		print(AudioServer.get_bus_volume_db(1))
		print(AudioServer.is_bus_mute(1))
	else:
		print(AudioServer.get_bus_volume_db(1))
		print(AudioServer.is_bus_mute(1))
		
func _on_AnimationPlayer_animation_finished(anim_name):
	global.start_scene_switch("res://Rooms/Area2/2-5/2-5.tscn", Vector2(0,0))
	global.swap_scenes()


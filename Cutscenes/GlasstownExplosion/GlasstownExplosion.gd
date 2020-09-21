extends Node2D

func _on_AnimationPlayer_animation_finished(anim_name):
	global.start_scene_switch("res://Rooms/Area5/5-3/5-3.tscn", Vector2(944,1977), "down")
	global.swap_scenes()

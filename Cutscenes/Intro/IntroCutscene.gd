extends Node2D

func _on_AnimationPlayer_animation_finished(anim_name):
	global.start_scene_switch("res://Rooms/Area1/1-1/1-1.tscn", Vector2(224,101))
	global.swap_scenes()

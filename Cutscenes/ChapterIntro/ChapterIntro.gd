extends Node2D

func _on_AnimationPlayer_animation_finished(anim_name):
	global.start_scene_switch("res://Rooms/Area2/2-1/2-1.tscn", Vector2(271, 28))
	global.swap_scenes()

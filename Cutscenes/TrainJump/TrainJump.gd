extends Node2D

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")

func _on_AnimationPlayer_animation_finished(anim_name):
	global.start_scene_switch("res://Rooms/Area8/8-3/8-3.tscn", Vector2(0,0), "down")
	global.swap_scenes()

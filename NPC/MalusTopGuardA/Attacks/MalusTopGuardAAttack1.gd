extends Node2D

signal cut_music

func _ready():
	yield(get_tree().create_timer(4), "timeout")
	global.start_scene_switch("res://Cutscenes/CapturedByGuards/CapturedByGuards.tscn", Vector2(0,0), "down")
	global.swap_scenes()

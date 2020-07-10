extends "res://Rooms/TemplateRoom.gd"


func _on_StartTimer_timeout():
	DiagHelper.start_talk(self)
	
func start_stage_1():
	$SleepStages.play("sleep_stage_1")
	
func start_stage_2():
	$SleepStages.play("sleep_stage_2")
	
func start_stage_3():
	$SleepStages.play("sleep_stage_3")
	yield(get_tree().create_timer(4), "timeout")
	global.start_scene_switch("res://Rooms/Area5/5-1/5-1.tscn", Vector2(3243,500), "down")
	global.swap_scenes()

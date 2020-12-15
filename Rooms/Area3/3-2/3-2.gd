extends "res://Rooms/TemplateRoom.gd"


func _on_ExitArea_body_entered(body):
	if body == $PhysicsPlayer:
		global.start_scene_switch("res://Rooms/Area4/4-1/4-1.tscn", Vector2(120, -216))
		global.swap_scenes()

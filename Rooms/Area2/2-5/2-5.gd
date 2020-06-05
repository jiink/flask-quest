extends "res://Rooms/TemplateRoom.gd"


func _on_StartTimer_timeout():
	DiagHelper.start_talk(self)

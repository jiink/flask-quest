extends Sprite

var toggled = false

var color_day = Color(0xffffffff)
var color_night = Color(0x2d3158ff)


func interact():
	if toggled == false:
		toggled = true
		$"../../CanvasModulate".color = color_night
		for night_lights in get_tree().get_nodes_in_group("night_lights"):
			night_lights.queue_free()
#		$"../..".level_music = preload("res://Rooms/Area4/Assets/maloffice-02.ogg")
#		MusicManager.update_music("level")
	else:
		toggled = false
		$"../../CanvasModulate".color = color_day
		for night_lights in get_tree().get_nodes_in_group("night_lights"):
			night_lights.visible = false
#		$"../..".level_music = preload("res://Rooms/Area4/Assets/maloffice-01.ogg")
#		MusicManager.update_music("level")

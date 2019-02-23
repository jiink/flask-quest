extends Camera2D

export(bool) var follow_player = true

func _process(delta):
	if follow_player:
		position = get_node("../YSort/Player").position
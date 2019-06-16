extends CanvasLayer

func get_visibility():
	for c in get_children():
		if c.visible:
			print(c.name)
			return true
	return false
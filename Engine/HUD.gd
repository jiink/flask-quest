extends CanvasLayer

func get_visibility():
	for c in get_children():
		if c.visible and c.name != "DebugModeWatermark":
			print("HUD visibility offender: %s" % c.name)
			return true
	return false

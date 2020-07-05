extends Sprite

var gp_hint_frame = 0

func setup(var flashy, var action_hint):
	$FlashTimer.connect("timeout", self, "_on_gp_flash_timeout")
		
	var action_hint_no2p = action_hint.trim_suffix("2")
	var action_to_frame = [
		"up", "down", "left", "right", "confirm", "cancel", "action", "special", "start"
	]
	gp_hint_frame = action_to_frame.find(action_hint_no2p) + 1 # frame 0 is empty
	frame = gp_hint_frame
	if flashy:
		$FlashTimer.start()
	
func _on_gp_flash_timeout():
	if frame == 0:
		frame = gp_hint_frame
	else:
		frame = 0

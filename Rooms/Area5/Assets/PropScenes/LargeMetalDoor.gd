extends Sprite

func animate_door_open(state):
	if state:
		$AnimationPlayer.play("open")
	else:
		$AnimationPlayer.play("close")
		
func set_door_open(state):
	if state:
		$AnimationPlayer.play("open_idle")
	else:
		$AnimationPlayer.play("close_idle")

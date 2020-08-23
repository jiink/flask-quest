extends Sprite

func set_door_open(state):
	if state:
		$AnimationPlayer.play("open")
	else:
		$AnimationPlayer.play("close")

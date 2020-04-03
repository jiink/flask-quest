extends Sprite

var already_open = 0

func interact():
	if already_open == 0:
		$AnimationPlayer.play("open")
		already_open = 1
		$PositionPortal/PortalCollision.disabled = false

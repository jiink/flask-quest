extends Sprite

var already_open = false

func interact():
	if already_open == false:
		$AnimationPlayer.play("open")
		already_open = true
		$PositionPortal/PortalCollision.disabled = false
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)

extends Node2D

export(bool) var filled = false

func _ready():
	$Area2D.connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body):
	# print("%s entered batterysocket" % body)
	if (not filled) and (body.name.find("Battery") != -1):
		# print("it was a battery")
		# if body.charged:
		body.set_locked(true)
		# bring it to center
		$Tween.interpolate_property(body, "position", null, position,
				0.4, Tween.TRANS_QUART, Tween.EASE_IN)
		$Tween.start()
		body.move_to(position)

		yield(get_tree().create_timer(0.5), "timeout") # suspense

		# if it's not charged, spit it back out
		if body.charged:
			filled = true
			body.get_node("Sprite").frame = 2
		else:
			var spit_pos = position.y + 30
			$Tween.interpolate_property(body, "position:y", null, spit_pos,
					0.4, Tween.TRANS_QUART, Tween.EASE_IN)
			$Tween.start()
			body.move_to(Vector2(body.position.x, spit_pos))
			body.set_locked(false)

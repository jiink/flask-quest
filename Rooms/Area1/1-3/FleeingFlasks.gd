extends Sprite

func _ready():
	$Tween.interpolate_property(self, "position:y", null, position.y + 100, 0.8)
	$Tween.start()
	yield($Tween, "tween_completed")
	queue_free()

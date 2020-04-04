extends Sprite

func _ready():
	$StopArea.connect("body_entered", self, "on_body_entered")
	$StopArea.connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	if body == global.get_player():
		get_node("../../AnimationPlayer").playback_speed = 0

func on_body_exited(body):
	if body == global.get_player():
		$Tween.interpolate_property(get_node("../../AnimationPlayer"), "playback_speed",
			0,1, 
			1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()

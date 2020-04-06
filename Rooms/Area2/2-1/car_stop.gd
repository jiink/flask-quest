extends Sprite

func _ready():
	$StopArea.connect("body_entered", self, "on_body_entered")
	$StopArea.connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player"):
		get_node("../../AnimationPlayer").playback_speed = 0
		$CarStop.play()
		$EngineAudio.pitch_scale = 0.43

func on_body_exited(body):
	if body in get_tree().get_nodes_in_group("Player"):
		$Tween.interpolate_property(get_node("../../AnimationPlayer"), "playback_speed",
			0,1, 
			1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		$Tween.interpolate_property(($EngineAudio), "pitch_scale",
			0.43,1, 
			1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()

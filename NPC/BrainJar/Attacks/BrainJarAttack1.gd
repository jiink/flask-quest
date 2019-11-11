extends Node2D

func _on_HomingMissile_successful_hit():
	$Timer.wait_time = 3.0
	$Timer.start()
		
	$Tween.interpolate_property($BattleSpeechBubble, "modulate",
	null, Color(1, 1, 1, 0),
	0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	
	$BattleSpeechBubble2.visible = true
	$Tween.interpolate_property($BattleSpeechBubble2, "modulate",
	Color(1, 1, 1, 0), Color(1, 1, 1, 1),
	0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	

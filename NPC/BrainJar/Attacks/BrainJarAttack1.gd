extends Node2D



func _on_HomingMissile_successful_hit():
	$Timer.set_wait_time(3.0)
	print("time to do stuff")
	$Tween.interpolate_property($BattleSpeechBubble, "modulate",
	null, Color(1, 1, 1, 0),
	0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	$BattleSpeechBubble2.visible = true
	$Tween.interpolate_property($BattleSpeechBubble2, "modulate",
	Color(1, 1, 1, 0), Color(1, 1, 1, 1),
	0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	

var t = 0
func _process(delta):
	t += 1
	if t%5 == 0: print($Timer.time_left)
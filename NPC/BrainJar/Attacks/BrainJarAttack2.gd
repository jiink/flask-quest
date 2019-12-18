extends Node2D

func _ready():
	$BrainWaveEmitter.set_process(false)

func _on_BrainBullet_successful_hit(player_num, dmg):
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


func _on_InitialWait_timeout():
	$BrainWaveEmitter.set_process(true)

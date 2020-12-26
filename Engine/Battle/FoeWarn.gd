extends AnimatedSprite

func _ready():
	playing = true
	$DelayTimer.start(rand_range(0, 0.15))
	yield($DelayTimer, "timeout")
	$AudioStreamPlayer.pitch_scale = rand_range(0.9, 1.1)
	$AudioStreamPlayer.play()
	$Timer.start()
	yield($Timer, "timeout")
	queue_free()
	
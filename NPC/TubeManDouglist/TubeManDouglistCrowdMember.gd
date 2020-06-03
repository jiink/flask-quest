extends AnimatedSprite

func _ready():
	set_frame(randi()%4)
	set_speed_scale(randf() * 0.3 + 0.75)
	play()

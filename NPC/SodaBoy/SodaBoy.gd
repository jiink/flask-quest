extends AnimatedSprite

func _init():
	playing = true
	
func interact():
	DiagHelper.start_talk(self)
extends AnimatedSprite

func interact():
	DiagHelper.start_talk(self)

func _ready():
	frame = randi()%4
	playing = true

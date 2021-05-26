extends Sprite

func _ready():
	var possible_frames = (hframes * vframes) - 1
	if possible_frames > 0:
		randomize()
		frame = randi() % (possible_frames + 1)

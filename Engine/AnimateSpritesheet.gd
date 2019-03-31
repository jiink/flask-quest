extends Sprite

export(float) var anim_speed
var t = 1

func _process(delta):
	t += anim_speed
	if t < hframes:
		frame = t
	else:
		frame = 0
		t = 0

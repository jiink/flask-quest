extends Sprite

export(float) var anim_speed
var t = 0

func _process(delta):
	t += anim_speed*delta
	if t < hframes * vframes:
		frame = t
	else:
		frame = 0
		t = 0

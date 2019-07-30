extends Sprite

export(int) var floornum = 255

func _process(delta):
	$Label.text = str(floornum)
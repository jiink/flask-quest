extends Sprite

export(int) var floornum = 255

func _ready():
	set_process(false)

func _process(delta):
	$Label.text = str(floornum)

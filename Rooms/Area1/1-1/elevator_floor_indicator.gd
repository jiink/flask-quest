extends Sprite

export(int) var floornum = 255
var floor_start

func _ready():
	set_process(false)
	
func _start():
	floor_start = int($Label.text)

func _process(delta):
	$Label.text = str(floornum)

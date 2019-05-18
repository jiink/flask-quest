extends Node

var t = 0
onready var p = get_parent()
func _process(delta):
	t += 1
	if t > 10000:
		t = 0
	p.fill_target = 10*sin(t/20.0)-5 + 50.0
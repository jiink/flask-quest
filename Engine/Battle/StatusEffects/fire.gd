extends Node

var level = 1
var damage
var parent

func _ready():
	print("Hi, I'm %s, and I now exist" % name)
	damage = 5 * level 
	parent = get_parent()
	if parent.get_class() == "Node2D":
		parent.set_modulate(Color(1, 0, 0, 1))
	else:
		print("Error, error: status effect parent invalid. Parent is %s" % parent.get_class())

func do_effect():
	print("Hi i'm a status effect and now i'm doing my thing")
	parent.get_hurt(damage + randi() % 10)

func relief():
	parent.set_modulate(Color(1, 1, 1, 1))
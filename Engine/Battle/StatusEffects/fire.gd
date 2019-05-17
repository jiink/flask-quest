extends Node

var level = 1
var damage
var parent

func _ready():
	damage = 5 * level 
	parent = get_parent()
	if parent.get_class() != "Node2D":
		print("Error, error: status effect parent invalid. Parent is %s" % parent.get_class())
		parent.set_modulate(1, 0, 0, 1)

func do_effect():
	parent.get_hurt(damage + randi() % 10)

func relief():
	parent.set_modulate(1, 1, 1, 1)
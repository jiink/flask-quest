extends Node

var level = 2
var duration
var damage
var parent

func _ready():
#	print("Hi, I'm %s, and I now exist" % name)
	damage = 2 * level 
	duration = level
	parent = get_parent()
	if parent.get_class() == "Node2D":
		parent.get_node("Sprite").get_material().set_shader(load("res://Engine/fire.shader"))
	else:
		print("Error, error: status effect parent invalid. Parent is %s" % parent.get_class())

func do_effect():
#	print("Hi i'm a status effect and now i'm doing my thing")
	parent.get_hurt(damage + randi() % 10)
	
	duration -= 1
	if duration <= 0:
		remove()

func remove():
	parent.get_node("Sprite").get_material().set_shader(null)
	queue_free()
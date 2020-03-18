extends Node

var level = 1
var duration = 1

func _ready():
	pass

func do_effect():
	print("Hi i'm a status effect and now i'm doing my thing")
	
	duration -= 1
	if duration < 0:
		expire()

func expire():
	print(name + " has expired and will now be gone")
	get_tree().get_current_scene().get_node("BattleScene").remove_effect_icon(name)
	queue_free()

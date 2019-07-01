extends Node

onready var diag = get_tree().get_current_scene().get_node("HUD/Diag")

func start_talk(obj, starting_branch = null):
	diag.start_talk(obj, starting_branch)
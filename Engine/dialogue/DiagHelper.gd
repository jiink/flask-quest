extends Node

func start_talk(obj, starting_branch = null):
	var diag = get_tree().get_current_scene().get_node("HUD/Diag")
	diag.start_talk(obj, starting_branch)
extends Node2D

func interact():
	if ItemManager.give_item("miniman_item"):
		queue_free()
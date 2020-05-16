extends "res://BasePickup.gd"


func interact():
	if global.get_player().position.x > position.x + 32 or \
			global.get_player().position.x < position.x - 32:
		ItemManager.give_item(item_name)
		print("You interacted with the %s script!" % name)
		get_node("../%sStaticBody2D/GapCollision" % name).disabled = false
		position.x = -776
		get_node("../%sStaticBody2D" % name).bridged = 0

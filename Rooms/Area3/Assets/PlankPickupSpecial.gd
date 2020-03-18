extends "res://BasePickup.gd"




func interact():
	if global.get_player().position.x > position.x + 32 or \
			global.get_player().position.x < position.x - 32:
		ItemManager.give_item(item_name)
		print("You interacted with the plank2 script!")
		$"../StaticBody2D/GapCollision".disabled = false
		position.x = -776
		get_node("../StaticBody2D").bridged = 0

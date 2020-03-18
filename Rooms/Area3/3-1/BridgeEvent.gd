extends StaticBody2D

var bridged = 0

func interact():
	if bridged == 0 and ItemManager.inventory.has("plank"):
		$GapCollision.disabled = true
		$"../PlankPickup2".position.x = 776
		bridged = 1
		print("bridged == 1")
		if $"../PlankPickup2".position.x == 776:
			print ("pickup plank 2 is now at origin of parent.")
#	else:
#		print(global.get_player().position.x)
#		if global.get_player().position.x > position.x + 32 or \
#			global.get_player().position.x < position.x - 32:
#				$GapCollision.disabled = false
#				$PlankPickup2.position.x = -1552
#				bridged = 0
#				print("bridged == 0, now there is no bridge.")

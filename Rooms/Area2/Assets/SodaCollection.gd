extends Node2D

# First interaction gives you the soda chemical
# All further interactions give you useless "soda"

export(int) var total_sodas = 14
var remaining_sodas = total_sodas

func interact():
	if remaining_sodas <= 0:
		return

	if remaining_sodas == total_sodas:
		ItemManager.give_item("peppy_pop")
	else:
		ItemManager.give_item("cruddy_cola")
	remaining_sodas -= 1
	
	$Sprite.frame += 1
	
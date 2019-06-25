extends "res://Engine/Items/ItemDB.gd"

var inventory = ['stone', 'stick', 'stick']
var loadout = ['base_potion', 'fire_chemical', 'base_potion']
var inventory_capacity = 4

func give_item(the_item):
	var player = get_tree().get_nodes_in_group("Player")[0]
	if is_inventory_full():
		if player:
			player.do_floaty_text("Inventory full!")
		print("Inventory full")
		return false
	else:
		inventory.append(the_item)
		if player:
			player.do_floaty_text("Obtained %s!" % items[the_item].name)
		return true

func is_inventory_full():
	return inventory.size() >= inventory_capacity

func _ready():
	pass
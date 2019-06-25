extends "res://Engine/Items/ItemDB.gd"

var inventory = ['stone', 'stick', 'stick']
var loadout = ['base_potion', 'fire_chemical', 'base_potion']
var inventory_capacity = 24

func give_item(the_item):
	var player = get_tree().get_nodes_in_group("Player")[0]
	if inventory.size() + 1 > inventory_capacity:
		if player:
			player.do_floaty_text("Inventory full!")
		print("Inventory full")
	else:
		inventory.append(the_item)
		if player:
			player.do_floaty_text("Obtained %s!" % items[the_item].name)

func _ready():
	pass
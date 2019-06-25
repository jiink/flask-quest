extends "res://Engine/Items/ItemDB.gd"

var inventory = ['stone', 'stick', 'stick']
var loadout = ['base_potion', 'fire_chemical', 'base_potion']
var loadout_capacity = 24

func give_item(the_item):
	var player = get_tree().get_nodes_in_group("Player")[0]
	if loadout.size() + 1 > loadout_capacity:
		if player:
			player.do_floaty_text("Loadout full!")
		print("Loadout full")
	else:
		loadout.append(the_item)
		if player:
			player.do_floaty_text("Obtained %s!" % the_item)

func _ready():
	pass
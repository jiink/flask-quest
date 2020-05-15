extends "res://Engine/Items/ItemDB.gd"

var inventory = ['stone', 'elevator_card', 'map_login']
var loadout = ['fire_chemical', 'exotic_excreta', 'miniman_item']
var inventory_capacity = 20

enum { ANY, INVENTORY, LOADOUT }

func give_item(the_item):
	var player = global.get_player(1)
	if is_inventory_full():
		if player:
			player.do_floaty_text("Inventory full!")
		return false
	else:
		inventory.append(the_item)
		if player:
			player.do_floaty_text("Obtained %s!" % items[the_item].name)
		return true
		
func toss_item(to_go, container, force=false): # container: 0 for inventory, 1 for loadout, -1 for both
	if (not items[to_go].has('droppable')) or force:
		var index
		if container == INVENTORY or container == ANY:
			index = inventory.find(to_go)
			if index == -1:
				print("%s not found!" % to_go)
				return
			inventory.remove(index)
		if container == LOADOUT or container == ANY:
			index = loadout.find(to_go)
			if index == -1:
				print("%s not found!" % to_go)
				return
			loadout.remove(index)
	else:
		print("Failed to throw away item, it's not droppable")
		get_tree().get_nodes_in_group("Player")[0].do_floaty_text("But this is important...")

func is_inventory_full():
	return inventory.size() >= inventory_capacity

func _ready():
	pass

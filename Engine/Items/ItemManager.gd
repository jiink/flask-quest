extends "res://Engine/Items/ItemDB.gd"

var inventory = ['stone', 'elevator_card']
var loadout = ['base_chemical', 'fire_chemical', ]
var inventory_capacity = 20

func give_item(the_item):
	var player = get_tree().get_nodes_in_group("Player")[0]
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
	if not items[to_go].has('droppable') or force:
		if container == 0 or container == -1:
			inventory.remove(to_go)
		if container == 1 or container == -1:
			loadout.remove(to_go)
	else:
		print("Failed to throw away item, it's not droppable")
		get_tree().get_nodes_in_group("Player")[0].do_floaty_text("But this is important...")

func is_inventory_full():
	return inventory.size() >= inventory_capacity

func _ready():
	pass

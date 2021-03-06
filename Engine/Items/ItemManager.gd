extends "res://Engine/Items/ItemDB.gd"

var inventory = []
var loadout = []
var inventory_capacity = 20
# what do you have in your ingredient bag?
var ingredient_bag = []
var ingredient_bag_capacity = 32 # how can ingredients can you have?
# these are ingredients that are recognized. add to this list as part of making a new ingredient
var valid_ingredients = [
	"lemon", "iron_shavings", "mundane_fluid", "tree_bark", "bleach", "vinegar", "hot_dog"
]

enum { ANY, INVENTORY, LOADOUT }


# given an item name (string), add it it to the `inventory` list, and if possible, notify the user of this
# returns `true` if item was added successfully, `false` otherwise
func give_item(the_item):
	var player = global.get_player(1)
	if is_inventory_full():
		if player:
			player.do_floaty_text("Inventory full!")
		return false
	else:
		if not items.has(the_item):
			print("Couldn't give item, %s is not an item" % the_item)
			return false
		inventory.append(the_item)
		if player:
			player.do_floaty_text("Obtained %s!" % items[the_item].name)
		return true

# throw away an item the player has
# `to_go`: the name of the item that will be thrown out
# `container`: enum, will this item be looked for in the INVENTORY, LOADOUT, or both (ANY)?
# `force`: throw away the item even if it's indespensible?
# returns nothing
func toss_item(to_go, container, force=false): # container: see enum near top
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
		global.get_player(1).do_floaty_text("But this is important...")

# given an ingredient name (string), add it it to the `ingredient_bag`
# returns `true` if ingridient was stored successfully, `false` otherwise
# todo: add feedback
func give_ingredient(requested_ingredient):
	# can't give the ingredient if the bag is full, the ingredient is not valid, or if you already have
	if (is_ingredient_bag_full() or (not valid_ingredients.has(requested_ingredient))
	or ingredient_bag.has(requested_ingredient)):
		return false
	
	# add
	ingredient_bag.append(requested_ingredient)
	return true


# disposes of an ingredient. returns `true` on success and `false` otherwise
func toss_ingredient(requested_ingredient):
	var index = ingredient_bag.find(requested_ingredient)
	if index == -1:
		print("can't throw away %s!" % requested_ingredient)
		return false
	ingredient_bag.remove(index)
	return true


func is_inventory_full():
	return inventory.size() >= inventory_capacity

func is_ingredient_bag_full():
	return ingredient_bag.size() >= ingredient_bag_capacity

# checks both inventory and loadout. returns true or false
func has_item(request):
	return inventory.has(request) or loadout.has(request)


func _ready():
	pass



extends "res://Engine/Items/ItemDB.gd"

#const item_db = preload("res://Engine/Items/ItemDB.gd")

var owned_items = ['stick', 'stick', 'stick', 'stone']


func _ready():
	
	for i in range(owned_items):
		owned_items[i] = item_list[owned_items[i]]
	
	print("Time to manage some items.\n")
	
	for item in owned_items:
		#print("%s\n%s\n" % [item_list[item].name, item_list[item].desc])
		print("%s\n%s\n" % [item.name, item.desc])
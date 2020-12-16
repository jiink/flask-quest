extends Node

var ingr_visual_handler_script = preload("res://Items/ingr_visual_handler.gd")
# the node where the visual handler will be added under
var node_path = global.get_hud().get_node_or_null("InventoryMenu")

# adds a handler node that will display all of the ingredients you have
func use():
	if node_path == null:
		print("ingredient bag script aborted")
		return

	var ingr_visual_handler = Node2D.new()
	ingr_visual_handler.set_script(ingr_visual_handler_script)
	node_path.add_child(ingr_visual_handler)

	

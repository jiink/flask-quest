# displays all of the ingredients you have in your ingredient bag when you use the ingredient bag
#  in your inventory
extends Node

# path to ingredient textures
const TEXTURE_PATH = "res://Items/Sprites/Ingredients/"

var ingr_visual_script = preload("res://Items/ingr_visual.gd")

# all of the Sprite nodes
var ingr_visuals = []

onready var inventorymenu = global.get_hud().get_node_or_null("InventoryMenu")

func _ready():
	if inventorymenu == null:
		print("ingr_visual_handler script aborted")
		return
	# where the bag icon is in the inventory. this is where the ingredients will come out of and go back to
	var bag_position = inventorymenu.get_node("ItemSelection").position + Vector2(4, -4)
	# let's get a tween node in here
	var tween = Tween.new()
	add_child(tween)	

	# if there's already a handler node get rid of it
	for m in get_tree().get_nodes_in_group("ingr_visual_handler"):
		m.queue_free()
	
	add_to_group("ingr_visual_handler")
	print("hello ingredients")

	for ingr in ItemManager.ingredient_bag:
		# create the new node
		var new_sprite = Sprite.new()
		# script is what makes it move
		# give it the appropriate texture, first find the texture
		var ingredient_texture_path = ("%s%s.png" % [TEXTURE_PATH, ingr])
		var ingredient_texture = load(ingredient_texture_path)
		new_sprite.centered = true
		new_sprite.set_texture(ingredient_texture)
		new_sprite.position = bag_position
		new_sprite.scale = Vector2.ZERO
		new_sprite.set_script(ingr_visual_script)
		add_child(new_sprite)
		ingr_visuals.append(new_sprite)
		tween.interpolate_property(new_sprite, "position:y", null, new_sprite.position.y - 40, 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.interpolate_property(new_sprite, "scale", Vector2.ZERO, Vector2.ONE, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
	yield(tween, "tween_all_completed")
	yield(get_tree().create_timer(0.1), "timeout")
	for i in ingr_visuals.size():
		tween.interpolate_property(ingr_visuals[i], "position:x", null, ingr_visuals[i].position.x + i * 32, 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
	
		# wait a variable amount of time before bringing the ingredient visuals back into the bag
	var see_time = 0.1 + log(ingr_visuals.size()) / log(10) * 2
	yield(get_tree().create_timer(see_time), "timeout")
	
	for ingr in ingr_visuals:
		tween.interpolate_property(ingr, "position", null, bag_position, 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.interpolate_property(ingr, "scale", Vector2.ONE, Vector2.ZERO, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
	
	# wait for them to go back in bag
	yield(get_tree().create_timer(see_time), "timeout")
	# clean everything up
	queue_free()

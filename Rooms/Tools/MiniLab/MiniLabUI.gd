extends Control

func modulo(a, b):
	return (a % b + b) % b

func random_vector(scale):
	var r1 = randf() * scale
	r1 -= r1 * 0.5
	var r2 = randf() * scale
	r2 -= r2 * 0.5
	return Vector2(r1, r2)

# spreads out your ingredients across a region of the UI, to be selected
func lay_out_ingredient_bag():
	# path to ingredient textures
	var TEXTURE_PATH = "res://Items/Sprites/Ingredients/"
	# lay out the ingredients that you have in the ingredient bag, scattered
	var region = $IngredientBagLayout/Region
	# Top-right corner of area the ingredients show up in
	var lowerbounds = Vector2(region.rect_position) 
	# Bottom-left corner of area the ingredients show up in
	var upperbounds = Vector2(region.rect_position + region.rect_size)
	var breathing_room = Vector2(8, 8)
	var scatter_amount = 24
	var ingredient_count = ItemManager.ingredient_bag.size()
	var column_count = 10 # approx how many columns the region can fit
	var row_count = 3 # approx how many rows the region can fit

	for i in ingredient_count:
		var ingr = ItemManager.ingredient_bag[i]
		var placement_pos = Vector2(
			lowerbounds.x + (upperbounds.x / column_count + breathing_room.x) * modulo(i, column_count), \
			lowerbounds.y + (upperbounds.y / row_count + breathing_room.y) * (int(i/column_count))
			)
		placement_pos += random_vector(scatter_amount).round()
		print("%s : %s" % [ingr, placement_pos])
		var new_ingredient_object = TextureRect.new()
		new_ingredient_object.set_texture(load(("%s%s.png" % [TEXTURE_PATH, ingr])))
		region.add_child(new_ingredient_object)
		new_ingredient_object.rect_position = placement_pos
	


func _ready():
	global.get_player().set_frozen(true, true)
	lay_out_ingredient_bag()


func close():
	global.get_player().set_frozen(false, true)
	queue_free()


func _input(event):
	if event.is_action_pressed("cancel"):
		close()
		get_tree().set_input_as_handled()



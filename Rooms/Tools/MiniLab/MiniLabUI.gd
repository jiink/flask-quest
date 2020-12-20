extends Control


var column_count = 10 # approx how many columns the ingredient region can fit
var row_count = 3 # approx how many rows the ingredient region can fit

# this is so you can't use the same ingredient twice in a recipe. gets cleared whenever the beaker\
#  is emptied. carries the indices, not the names
var already_used_ingredients = [] 

#onready var cursor = $Cursor
# lay out the ingredients that you have in the ingredient bag, scattered
onready var region = $IngredientBagLayout/Region
onready var region_location = $IngredientBagLayout.rect_position + $IngredientBagLayout/Region.rect_position

onready var ml_cursor_scene = preload("res://Rooms/Tools/MiniLab/MLCursor.tscn")

# sounds
onready var sounds_ingr = [
	preload("res://Rooms/Tools/MiniLab/ingredient_use0.wav"),
	preload("res://Rooms/Tools/MiniLab/ingredient_use1.wav"),
	preload("res://Rooms/Tools/MiniLab/ingredient_use2.wav"),
	preload("res://Rooms/Tools/MiniLab/ingredient_use3.wav"),
	preload("res://Rooms/Tools/MiniLab/ingredient_use4.wav")
]
onready var audio = $AudioStreamPlayer

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
	
	# Top-right corner of area the ingredients show up in
	var lowerbounds = Vector2.ZERO #Vector2(region.rect_position) 
	# Bottom-left corner of area the ingredients show up in
	var upperbounds = region.rect_size #Vector2(region.rect_position + region.rect_size)
	var breathing_room = Vector2(8, 8)
	var scatter_amount = 24
	var ingredient_count = ItemManager.ingredient_bag.size()
	

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
	


func cursor_scan():
	pass



# places the selected ingredient into the beaker
func use_ingredient(index):
	if not (index in already_used_ingredients):
		already_used_ingredients.append(index)
		var ingr_name = ItemManager.ingredient_bag[index]
		$MiniLabBeaker.add_contents(ingr_name)
	
		var use_sound = sounds_ingr[randi() % sounds_ingr.size()]
		audio.stream = use_sound
		audio.play()


func _ready():
	global.freeze_all_players(true)
	lay_out_ingredient_bag()
	# spawn the cursor(s)
	for i in range(PlayerStats.player_count):
		var p = i + 1
		print("hello cursor %s" % p)
		var new_ml_cursor = ml_cursor_scene.instance()
		new_ml_cursor.player_number = p
		add_child(new_ml_cursor)


func close():
	print("MLUI closngi!")
	global.freeze_all_players(false)
	queue_free()


func _input(event):
	if event.is_action_pressed("cancel"):
		close()
		get_tree().set_input_as_handled()

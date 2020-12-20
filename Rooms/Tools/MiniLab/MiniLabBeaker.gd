extends Node2D

# what ingredients are in here?
var contents = [] 
var chemical_recipe_book
onready var chemical_recipe_data = preload("res://Rooms/Tools/MiniLab/chemical_recipes.gd")

onready var sound_fail = preload("res://Rooms/Tools/MiniLab/ml_result_fail.wav")
onready var sound_success = preload("res://Rooms/Tools/MiniLab/ml_result_success.wav")

func _ready():
	chemical_recipe_book = Node.new()
	chemical_recipe_book.set_script(chemical_recipe_data)

func add_contents(new_contents):
	contents.append(new_contents)

	var label_string = ""
	for i in contents:
		label_string += "%s, " % i
	$ContentsLabel.text = label_string


# this is when a chemical is possibly made
# this checks its contents against data that tells what ingredient combinations \
# make what chemicals. upon success, the chemical will be made and stored in the inventory
# upon failure, the beaker will look like it's being disposed and it will look like a \
# new one took its place.
func get_stirred():
	# find match in recipe book
	var result = ""
	var counter = 0
	# we sort the contents and recipes so that order doesn't matter
	contents.sort()
	for k in chemical_recipe_book.recipes.keys():
		var recipe = chemical_recipe_book.recipes[k].duplicate()
		recipe.sort()
		#print(" %s == %s" % [sorted_contents, recipe_sorted])
		if recipe == contents:
			result = chemical_recipe_book.recipes.keys()[counter]
			break
		counter += 1
		
	contents = [] # empty contents
	$ContentsLabel.text = result

	# give the chemical
	if (result != ""):
		if not ItemManager.has_item(result):
			ItemManager.give_item(result)
		$AudioStreamPlayer.stream = sound_success
	else:
		$AudioStreamPlayer.stream = sound_fail
	$AudioStreamPlayer.play()
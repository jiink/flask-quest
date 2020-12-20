extends Node2D

var point_offset = Vector2(8, 8) # has to do with texture size of ingredients

enum CursorDirection {UP, DOWN, LEFT, RIGHT}
enum Zone { INGREDIENT_PLATE, STIRRING_ROD } # the distinct areas that you cursor can go

# the index of the ingredient that is being hovered over with the cursor
var ingredient_hovered_index = 0
var focused_zone = Zone.INGREDIENT_PLATE
var cursor_sensitivity = 70.0
var player_number = 1 # P1 or P2 controlling this? changes the inputs

var player_controls = ["up", "down", "left", "right", "confirm", "cancel", "action"]

onready var ml_ui = get_parent() # the minilab UI 
onready var stirring_rod = ml_ui.get_node("MLStirringRod")
onready var ml_region = ml_ui.get_node("IngredientBagLayout/Region")
onready var ml_region_location = ml_ui.get_node("IngredientBagLayout").rect_position + \
	ml_ui.get_node("IngredientBagLayout/Region").rect_position

func cursor_move(destination):
	$Tween.interpolate_property(
		self, "position", null, destination + point_offset,
		0.05, Tween.TRANS_QUAD
	)
	$Tween.start()
	
	var a = $AnimatedSprite
	a.stop()
	a.frame = 0
	a.set_animation("tap")
	a.play()


func selection_move(where):
	match focused_zone:
		Zone.INGREDIENT_PLATE:
			match where:
				CursorDirection.UP:
					if ingredient_hovered_index - ml_ui.column_count >= 0:
						ingredient_hovered_index -= ml_ui.column_count
				CursorDirection.DOWN:
					if ingredient_hovered_index + ml_ui.column_count <= (ItemManager.ingredient_bag.size() - 1):
						ingredient_hovered_index += ml_ui.column_count
				CursorDirection.LEFT:
					if ingredient_hovered_index == 0:
						# go to the stirring rod
						focused_zone = Zone.STIRRING_ROD
						cursor_move(stirring_rod.position)
						return # -------- sorry, but get out!

					ingredient_hovered_index -= 1
				CursorDirection.RIGHT:
					ingredient_hovered_index += 1

			# correct ingredient_hovered_index bounds
			ingredient_hovered_index = clamp(ingredient_hovered_index, 
				0, ItemManager.ingredient_bag.size() - 1)
			
			$Label.text = "hovered ingreidnet: %s at %s" % [ingredient_hovered_index , ml_region.get_child(ingredient_hovered_index).rect_position]

			# now move the cursor there
			cursor_move(ml_region.get_child(ingredient_hovered_index).rect_position + ml_region_location)
		Zone.STIRRING_ROD:
			match where:
				CursorDirection.RIGHT:
					# let the selection go back to the ingredient plate
					focused_zone = Zone.INGREDIENT_PLATE
					cursor_move(ml_region.get_child(ingredient_hovered_index).rect_position + ml_region_location)


func _ready():
	# place the cursor on the first ingredient, if there are any
	if ml_region.get_child(0):
		cursor_move(ml_region.get_child(0).rect_position + ml_region_location)
	# set up player-specific stuff
	match player_number:
		1:
			modulate = global.GREEN_COLOR
		2:
			modulate = global.ORANGE_COLOR
			for i in player_controls.size():
				player_controls[i] += String(player_number)
		3:
			for i in player_controls.size():
				player_controls[i] += String(player_number)
		_:
			queue_free()
	point_offset += Vector2(player_number*2, player_number*2)
	print(player_controls)
		


func _input(event):
	
	if event.is_action_pressed(player_controls[CursorDirection.UP]):
		selection_move(CursorDirection.UP)
	elif event.is_action_pressed(player_controls[CursorDirection.DOWN]):
		selection_move(CursorDirection.DOWN)
	elif event.is_action_pressed(player_controls[CursorDirection.LEFT]):
		selection_move(CursorDirection.LEFT)
	elif event.is_action_pressed(player_controls[CursorDirection.RIGHT]):
		selection_move(CursorDirection.RIGHT)
	elif event.is_action_pressed(player_controls[4]):
		match focused_zone:
			Zone.INGREDIENT_PLATE:
				ml_ui.use_ingredient(ingredient_hovered_index)
			Zone.STIRRING_ROD:
				ml_ui.get_node("MiniLabBeaker").get_stirred()
				ml_ui.already_used_ingredients = []
		

extends Node2D

onready var manager = get_node("/root/ItemManager")
onready var item_options = get_node("InfoBar/ItemOptions")
var item_selection
var selection_index = 0

var selected_option = 0

func update_list():
	
	for child in $GridContainer.get_children():
		child.queue_free()
	
	for item in manager.owned_items:
		var item_codename = item
		item = manager.item_list[item]
		var item_sprite = TextureRect.new()
		item_sprite.set_name(item.name)
		item_sprite.set_texture(load("res://Items/Sprites/%s.png" % item_codename))
		$GridContainer.add_child(item_sprite)
	
	#update_item_selection(selection_index)
	

func update_item_selection(index):
	selection_index = clamp(selection_index, 0, manager.owned_items.size()-1)
	if manager.owned_items.size() > 0:
		item_selection.set_position($GridContainer.get_children()[selection_index].get_global_position() + Vector2(8,8)) 

func _ready():
	update_list()
	item_selection = Sprite.new()
	item_selection.set_name("ItemSelection")
	item_selection.set_texture(load("res://Items/Sprites/itemSelection.png"))
	add_child(item_selection)
	update_item_selection(selection_index)
	
	
func _process(delta):
	
	if Input.is_action_just_pressed("b") and get_node("../Diag").visible == false:
		if not $InfoBar.visible:
			set_visible(!visible)
			get_tree().get_nodes_in_group("Player")[0].frozen = visible
		else:
			$InfoBar.set_visible(false)
	
	if visible:
		if not $InfoBar.visible:
			
			if Input.is_action_just_pressed("right"):
				selection_index += 1
				update_item_selection(selection_index)
			elif Input.is_action_just_pressed("left"):
				selection_index -= 1
				update_item_selection(selection_index)
			
			if Input.is_action_just_pressed("a") and manager.owned_items.size() > 0:
				$InfoBar/Label.text = "%s\n%s" % [manager.item_list[manager.owned_items[selection_index]].name,
												  manager.item_list[manager.owned_items[selection_index]].desc]
				$InfoBar.set_visible(true)
		else:
			if Input.is_action_just_pressed("up"):
				selected_option -= 1
			elif Input.is_action_just_pressed("down"):
				selected_option += 1
			selected_option = clamp(selected_option, 0, item_options.get_node("Choices").get_children().size() - 1)
			item_options.get_node("Selection").position = item_options.get_node("Choices").get_child(selected_option).position
			
			if Input.is_action_just_pressed("a") and item_options.get_node("Choices").get_child(selected_option).name == "Toss":
				toss_item(selection_index)
				update_list()
				$InfoBar.set_visible(false)
			
func toss_item(ind):
	manager.owned_items.remove(ind)
	if $InfoBar.visible:
		update_item_selection(selection_index)
extends Node2D

onready var manager = get_node("/root/ItemManager")
onready var item_options = get_node("InfoBar/ItemOptions")
onready var container = get_node("Inventory/GridContainer")
#onready var item_list = get_node("/root/ItemManager").inventory

var item_selection
var selection_index = 0

var selected_option = 0

enum {
	INVENTORY,
	LOADOUT,
}
var state = INVENTORY

func update_list():
	
	# main inventory
	
	for child in $Inventory/GridContainer.get_children():
		child.queue_free()
	
	for item in manager.inventory:
		var item_codename = item
		item = manager.items[item]
		var item_sprite = TextureRect.new()
		item_sprite.set_name(item.name)
		item_sprite.set_texture(load("res://Items/Sprites/%s.png" % item_codename))
		$Inventory/GridContainer.add_child(item_sprite)
	
	# loadout
	
	for child in $Loadout/GridContainer.get_children():
		child.queue_free()

	for item in manager.loadout:
		var item_codename = item
		item = manager.items[item]
		var item_sprite = TextureRect.new()
		item_sprite.set_name(item.name)
		var sprite_texture = load("res://Items/Sprites/%s.png" % item_codename)
		if not sprite_texture:
			sprite_texture = load("res://Items/Sprites/missing_item.png")
		item_sprite.set_texture(sprite_texture)
			
		$Loadout/GridContainer.add_child(item_sprite)
		
	#print("ld: %s\ninv: %s" % [manager.loadout, manager.inventory])

func update_item_selection(index):
	selection_index = clamp(selection_index, 0, get_item_list().size()-1)
	if get_item_list().size() > 0:
		item_selection.set_position(container.get_children()[selection_index].get_global_position() + Vector2(12,12)) 

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
				
				if state == LOADOUT:
					if get_column() == manager.loadout.size() - 1:
						state = INVENTORY
						container = get_node("Inventory/GridContainer")
					else:
						selection_index += 1
				
				elif state == INVENTORY and get_column() != 2:
					selection_index += 1
			elif Input.is_action_just_pressed("left"):
				
				if state == INVENTORY and get_column() == 0:
					state = LOADOUT
					container = get_node("Loadout/GridContainer")
				
				
				selection_index -= 1
				
			
			elif Input.is_action_just_pressed("up"):
				selection_index -= 3
			
			elif Input.is_action_just_pressed("down"):
				selection_index += 3
			
			elif Input.is_action_just_pressed("a") and get_item_list().size() > 0:
				$InfoBar/Label.text = "%s\n%s" % [manager.items[get_item_list()[selection_index]].name,
												  manager.items[get_item_list()[selection_index]].desc]
				$InfoBar.set_visible(true)
				
				if state == INVENTORY:
					$InfoBar/ItemOptions/Choices/Equip/Label.text = "Equip"
				elif state == LOADOUT:
					$InfoBar/ItemOptions/Choices/Equip/Label.text = "Unequip"
			
			
			if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left") or Input.is_action_just_pressed("down"):
				update_item_selection(selection_index)
			
		else:
			if Input.is_action_just_pressed("up"):
				selected_option -= 1
			elif Input.is_action_just_pressed("down"):
				selected_option += 1
			selected_option = clamp(selected_option, 0, item_options.get_node("Choices").get_children().size() - 1)
			item_options.get_node("Selection").position = item_options.get_node("Choices").get_child(selected_option).position
			
			if Input.is_action_just_pressed("a"):
				if item_options.get_node("Choices").get_child(selected_option).name == "Toss":
					toss_item(selection_index)
					update_list()
					$InfoBar.set_visible(false)
				
				elif item_options.get_node("Choices").get_child(selected_option).name == "Equip":
					if state == INVENTORY:
						if manager.loadout.size() <3:
							equip_item(selection_index)
							$InfoBar.set_visible(false)
						else:
							print("loadout full")
					else:
						equip_item(selection_index)
						$InfoBar.set_visible(false)
						
func get_column():
	var col_count
	if state == INVENTORY:
		col_count = $Inventory/GridContainer.columns
	else:
		col_count = $Loadout/GridContainer.columns
		
	return fmod(selection_index, col_count)
	
	
func toss_item(ind):
	manager.inventory.remove(ind)
	if $InfoBar.visible:
		update_item_selection(selection_index)

func equip_item(ind):
	if state == INVENTORY:
		manager.loadout.append(manager.inventory[ind])
		toss_item(ind)
	else:
		manager.inventory.append(manager.loadout[ind])
		manager.loadout.remove(ind)
		update_item_selection(selection_index)
	update_list()
	
func get_item_list():
	if state == INVENTORY:
		return get_node("/root/ItemManager").inventory
	return get_node("/root/ItemManager").loadout
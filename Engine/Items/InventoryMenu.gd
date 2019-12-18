extends Node2D

onready var manager = get_node("/root/ItemManager")
onready var item_options = get_node("InfoBar/ItemOptions/Choices")
onready var money_label = get_node("Money")
onready var container = get_node("Inventory/GridContainer")
onready var audio = get_node("AudioStreamPlayer")
#onready var item_list = get_node("/root/ItemManager").inventory

onready var horiz_sound = preload("res://SoundEffects/ui_move_1.wav")
onready var vert_sound = preload("res://SoundEffects/ui_move_2.wav")

var item_selection
var selection_index = 0

var selected_option = 0

enum {
	INVENTORY,
	LOADOUT,
}

var state = INVENTORY
var in_battle = false
var battle
var bchoicenode
var loadout_changed = false

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
	
	# money label
	
	money_label.text = "$%s" % PlayerStats.dollars
	
	if in_battle:
		battle.update_chem_loadout()
	
	
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
	$InfoBar.set_visible(false)
	in_battle = not has_node("../Diag")
	if in_battle:
		battle = get_parent()
		bchoicenode = battle.get_node("BattleChoices")
		
func _process(delta):

	if visible:
		if not $InfoBar.visible:
			
			if Input.is_action_just_pressed("right"):
				selection_index += 1
				
			elif Input.is_action_just_pressed("left"):
				selection_index -= 1
								
			elif Input.is_action_just_pressed("up"):
				if state == INVENTORY:
					if selection_index < 11:
						selection_index = 0
						state = LOADOUT
						container = get_node("Loadout/GridContainer")
					else:
						selection_index -= 11
					
			elif Input.is_action_just_pressed("down"):
				if state == LOADOUT:
					selection_index = 0
					state = INVENTORY
					container = get_node("Inventory/GridContainer")
				else:
					selection_index += 11
				
			elif Input.is_action_just_pressed("confirm") and get_item_list().size() > 0:
				$InfoBar/Label.text = "%s\n%s" % [manager.items[get_item_list()[selection_index]].name,
												  manager.items[get_item_list()[selection_index]].desc]
				$InfoBar.set_visible(true)
				
#				if state == INVENTORY:
#					$InfoBar/ItemOptions/Choices/Equip/Label.text = "Equip"
#				elif state == LOADOUT:
#					$InfoBar/ItemOptions/Choices/Equip/Label.text = "Unequip"
			
			
			if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left") or Input.is_action_just_pressed("down"):
				update_item_selection(selection_index)
			
		else:
			if Input.is_action_just_pressed("left"):
				selected_option -= 1
			elif Input.is_action_just_pressed("right"):
				selected_option += 1
			selected_option = clamp(selected_option, 0, item_options.get_children().size() - 1)
#			item_options.get_node("Selection").position = item_options.get_node("Choices").get_child(selected_option).position
			update_item_action_icons()
			
			if Input.is_action_just_pressed("confirm"):
				match item_options.get_child(selected_option).name:
					"Toss":
						toss_item(selection_index)
						update_list()
						$InfoBar.set_visible(false)
						if in_battle and state == LOADOUT:
							loadout_changed = true
				
					"Equip":
						if state == INVENTORY:
							if manager.loadout.size() <3:
								equip_item(selection_index)
								$InfoBar.set_visible(false)
								if in_battle and state == LOADOUT:
									loadout_changed = true
							else:
								print("loadout full")
						else:
							equip_item(selection_index)
							$InfoBar.set_visible(false)
							if in_battle and state == LOADOUT:
								loadout_changed = true
					"Use":
#						print("Using items isn't a thing yet")
						var item_script_path = "res://Items/Scripts/%s.gd" % get_item_list()[selection_index]
						var directory = Directory.new()
						var doFileExists = directory.file_exists(item_script_path)
						if doFileExists:
							var item_script = load(item_script_path).new()
							item_script.use()
							toss_item(selection_index)
							update_list()
							$InfoBar.set_visible(false)
						else:
							print("the %s item doesn't have a use-script" % get_item_list()[selection_index])
		if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
				audio.stream = horiz_sound
				audio.play()
		elif Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
				audio.stream = vert_sound
				audio.play()
	if not in_battle:
		
		if Input.is_action_just_pressed("cancel") and get_node("../Diag").visible == false:
			if not $InfoBar.visible:
				if not visible:
					if not get_tree().get_nodes_in_group("Player")[0].frozen:
						set_visible(true)
				else:
					set_visible(false)
				get_tree().get_nodes_in_group("Player")[0].frozen = visible
				update_list()
			else:
				$InfoBar.set_visible(false)
	else:
		
#		if bchoicenode.ready_for_inv:
		if battle.selected_battle_choice == "item" and battle.state == battle.PLAYER_TURN:
			
			if Input.is_action_just_pressed("confirm"):
				if not visible:
					set_visible(true)
					update_list()
			elif Input.is_action_just_pressed("cancel"):
				if visible:
					if not $InfoBar.visible:
						set_visible(false)
						battle.battle_choice_confirmed = false
						if loadout_changed:
							yield(get_tree().create_timer(0.8), "timeout")
							battle.state = battle.ENEMY_TURN
							loadout_changed = false
					else:
						$InfoBar.set_visible(false)
	

func get_column():
	var col_count
	if state == INVENTORY:
		col_count = $Inventory/GridContainer.columns
	else:
		col_count = $Loadout/GridContainer.columns
		
	return fmod(selection_index, col_count)
	
	
func toss_item(ind):
	if not manager.items[get_item_list()[selection_index]].has('droppable'):
		manager.inventory.remove(ind)
		if $InfoBar.visible:
			update_item_selection(selection_index)
	else:
		print("Failed to throw away item")
		get_tree().get_nodes_in_group("Player")[0].do_floaty_text("But this is important...")

func equip_item(ind):
	if manager.items[get_item_list()[selection_index]].has('equippable'):
		if state == INVENTORY:
			manager.loadout.append(manager.inventory[ind])
			toss_item(ind)
		else:
			manager.inventory.append(manager.loadout[ind])
			manager.loadout.remove(ind)
			update_item_selection(selection_index)
		update_list()

func update_item_action_icons():
	for c in item_options.get_children():
		c.frame = 1
	item_options.get_child(selected_option).frame = 0

func get_item_list():
	if state == INVENTORY:
		return get_node("/root/ItemManager").inventory
	return get_node("/root/ItemManager").loadout
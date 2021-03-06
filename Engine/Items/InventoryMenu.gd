extends Node2D

onready var manager = get_node("/root/ItemManager")
onready var item_options = get_node("InfoBar/ItemOptions/Choices")
onready var money_label = get_node("Money")
onready var container = get_node("Inventory/GridContainer")
onready var audio = get_node("AudioStreamPlayer")
#onready var item_list = get_node("/root/ItemManager").inventory

onready var horiz_sound = preload("res://SoundEffects/ui_move_1.wav")
onready var vert_sound = preload("res://SoundEffects/ui_move_2.wav")
onready var close_sound = preload("res://Engine/Items/inventory_close.wav")
onready var open_sound = preload("res://Engine/Items/inventory_open.wav")

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

func update_in_battle():
	#in_battle = (get_parent().name.find("BattleScene") != -1) #not has_node("../Diag")
	battle = get_tree().get_current_scene().get_node_or_null("BattleScene")
	in_battle = (battle != null)
	if in_battle:
		bchoicenode = battle.get_node("BattleChoices")


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
	
	update_in_battle()

	if in_battle:
		battle.update_chem_loadout()
	
	
func update_item_selection(index):
	print(ItemManager.inventory)
	selection_index = clamp(selection_index, 0, get_item_list().size()-1)
	print(get_item_list().size())
	print(selection_index)
	if(get_item_list().size() > 0) and (container.get_children().size() > selection_index): # whatever...
		item_selection.set_position(container.get_children()[selection_index].get_global_position() + Vector2(12,12)) 

func _ready():
	update_list()
	item_selection = Sprite.new()
	item_selection.set_name("ItemSelection")
	item_selection.set_texture(load("res://Items/Sprites/itemSelection.png"))
	add_child(item_selection)
	item_selection.position.x = -64 # off the screen in case there's no items
	update_item_selection(selection_index)
	$InfoBar.set_visible(false)
	in_battle = (get_parent().name.find("BattleScene") != -1) #not has_node("../Diag")
	if in_battle:
		battle = get_parent()
		bchoicenode = battle.get_node("BattleChoices")
	

func open():
	set_visible(true)
	audio.stream = open_sound
	audio.play()


func close():
	set_visible(false)
	audio.stream = close_sound
	audio.play()


func is_action_pressed_2p(action, event):
	# in the overworld, look for inputs from either player.
	# in battles, look for inputs only from the person who's turn it is
	if in_battle:
		match battle.whos_turn:
			1:
				return event.is_action_pressed(action)
			2:
				return event.is_action_pressed(action + "2")
			_:
				print("InventoryMenu: i dunno what to do when it's P%s's turn" % battle.whos_turn)
				return false
	else:
		return event.is_action_pressed(action) or event.is_action_pressed(action + "2")


func _unhandled_input(event):

	update_in_battle()

	if visible:
		if not $InfoBar.visible:
			
			if is_action_pressed_2p("right", event):
				selection_index += 1
			elif is_action_pressed_2p("left", event):
				selection_index -= 1
			elif is_action_pressed_2p("up", event):
				if state == INVENTORY:
					if selection_index < 11:
						selection_index = 0
						state = LOADOUT
						container = get_node("Loadout/GridContainer")
					else:
						selection_index -= 11
					
			elif is_action_pressed_2p("down", event):
				if state == LOADOUT:
					selection_index = 0
					state = INVENTORY
					container = get_node("Inventory/GridContainer")
				else:
					selection_index += 11
				
			elif is_action_pressed_2p("confirm", event) and get_item_list().size() > 0:
				$InfoBar/Label.text = "%s\n%s" % [manager.items[get_item_list()[selection_index]].name,
													manager.items[get_item_list()[selection_index]].desc]
				$InfoBar.set_visible(true)
				# grey-out the trash can icon if it's in the loadout
				if state == LOADOUT:
					$InfoBar/ItemOptions/Choices/Toss.modulate = Color(0x72377b)
				else:
					$InfoBar/ItemOptions/Choices/Toss.modulate = Color(1, 1, 1, 1)
				#if state == INVENTORY:
					#$InfoBar/ItemOptions/Choices/Equip/Label.text = "Equip"
				#elif state == LOADOUT:
					#$InfoBar/ItemOptions/Choices/Equip/Label.text = "Unequip"
			if is_action_pressed_2p("up", event) or is_action_pressed_2p("right", event) or is_action_pressed_2p("left", event) or is_action_pressed_2p("down", event):
				update_item_selection(selection_index)
			
		else:
			if is_action_pressed_2p("left", event):
				selected_option -= 1
			elif is_action_pressed_2p("right", event):
				selected_option += 1
			selected_option = clamp(selected_option, 0, item_options.get_children().size() - 1)
			#item_options.get_node("Selection").position = item_options.get_node("Choices").get_child(selected_option).position
			update_item_action_icons()
			
			if is_action_pressed_2p("confirm", event):
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
						var item_script_path = "res://Items/Scripts/%s.gd" % get_item_list()[selection_index]
						var directory = Directory.new()
						var doFileExists = directory.file_exists(item_script_path)
						if doFileExists:
							var item_script = load(item_script_path).new()
							item_script.use()
							var item_listing = manager.items[get_item_list()[selection_index]]
							if (item_listing.has('consumable') and item_listing.get('consumable') == true) or (not item_listing.has('consumable')):
								toss_item(selection_index)
								update_list()
							$InfoBar.set_visible(false)
						else:
							print("the %s item doesn't have a use-script" % get_item_list()[selection_index])
		if is_action_pressed_2p("right", event) or is_action_pressed_2p("left", event):
				audio.stream = horiz_sound
				audio.play()
		elif is_action_pressed_2p("up", event) or is_action_pressed_2p("down", event):
				audio.stream = vert_sound
				audio.play()
	if (not in_battle):
		
		if is_action_pressed_2p("cancel", event):
			if not $InfoBar.visible:
				if not visible:
					if (not global.get_player().frozen) and (get_parent().get_visibility() == false):
						open()
						update_item_selection(3)
						
				else:
					close()
				global.get_player().set_frozen(visible, true)
				update_list()
			else:
				$InfoBar.set_visible(false)
	else:
		
		#if bchoicenode.ready_for_inv:
		if battle.selected_battle_choice == "item" and battle.state == battle.PLAYER_TURN:
			
			if is_action_pressed_2p("confirm", event):
				if not visible:
					open()
					update_list()
			elif is_action_pressed_2p("cancel", event):
				if visible:
					if not $InfoBar.visible:
						close()
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
	
	
func toss_item(ind, forced = false):
	if state == LOADOUT:
		print("Failed to throw away item")
		get_tree().get_nodes_in_group("Player")[0].do_floaty_text("I should unequip it first...")
		return
		
	if not manager.items[get_item_list()[selection_index]].has('droppable') or forced:
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
			toss_item(ind, true)
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

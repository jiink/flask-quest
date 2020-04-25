extends Node

signal hit_foe
signal foe_attack_completed

signal open_chems
signal close_chems

enum {
	WAIT,
	PLAYER_TURN,
	PLAYER_CHOOSE_ENEMY,
	POURING,
	ENEMY_TURN,
	DODGE_GAME,
}
	
enum {
	MENU,
	INV,
}

enum {
	OFFENSIVE,
	DEFENSIVE
}

var defined_foe_positions = [
	[Vector2(192, 161)],
	[Vector2(160, 161), Vector2(224, 161)],
	[Vector2(139, 181), Vector2(192, 155), Vector2(245, 181)],
	[Vector2(112, 182), Vector2(165, 156), Vector2(221, 187), Vector2(274, 161)],
	[Vector2(104, 158), Vector2(147, 191), Vector2(194, 160), Vector2(246, 189), Vector2(299, 163)]
]

var focused_menu = MENU
var state = PLAYER_TURN
var selected_foe = 0
var selected_chem = 0
var selected_chem_category = OFFENSIVE

var selected_battle_choice = "attack"
var battle_choice_confirmed = false


var whos_turn = 1 # is it P1's turn, or P2's turn?

# for the player who's turn it is
var player_up = "up"
var player_down = "down"
var player_left = "left"
var player_right = "right"

var player_confirm = "confirm"
var player_cancel = "cancel"
var player_action = "action"

# for the player who's turn it isn't
var other_player_up = "up2"
var other_player_down = "down2"
var other_player_left = "left2"
var other_player_right = "right2"

var other_player_confirm = "confirm2"
var other_player_cancel = "cancel2"
var other_player_action = "action2"


onready var global = get_node("/root/global")
onready var item_manager = get_node("/root/ItemManager")

var foe = load("res://NPC/BaseFoe/BaseFoe.tscn")

var new_effect_icon = preload("res://Engine/Battle/StatusEffects/Icons/EffectIcon.tscn")

var total_dollar_reward = 0

onready var player_node = $PouringEvent/FillingFlask

func _ready():
	print("battlescene starting!!")
	connect("open_chems", $BattleChoices, "open_chems")
	connect("close_chems", $BattleChoices, "close_chems")
	
	
	print(global.initial_enemies)
	for i in range(global.initial_enemies.size()):
		var foe = load("res://NPC/" + global.initial_enemies[i] + "/" + global.initial_enemies[i] + "Foe.tscn")
		var foe_instance = foe.instance()
		foe_instance.set_name(global.initial_enemies[i])
		# if there are 5 or less enemies, use predetermined positions
		# otherwise use random ones
		if global.initial_enemies.size() <= 5:
			foe_instance.position = defined_foe_positions[global.initial_enemies.size() - 1][i]
		else:
			foe_instance.position.x = int(randf()*(345-84)+84) #84 to 345
			foe_instance.position.y = int(randf()*(190-128)+128) #128 to 190
		$Foes.add_child(foe_instance)
		
	global.current_enemies = global.initial_enemies
	
#	var custom_music_gonna_play = false
#	for foe in get_foes():
#		if foe.custom_music != null:
#			MusicManager.update_music(foe.custom_music)
#			custom_music_gonna_play = true
#			break
#	if not custom_music_gonna_play:
#		print("There is NO custom music to play!!!!")
#		MusicManager.update_music("battle")
	
	# battle bg
	$BattleBG.texture = global.battle_bg
	
	# put down the chemicals
	update_chem_loadout()
	
#	# set all the lightmasks to 0 so the overworld lighting doesnt affect this
#	$LightingRemover.remove_lighting(self)
	
	# hide all them lights
	toggle_lighting(get_tree().get_current_scene(), false)
	
	# get the foe arrow in the right spot
	set_arrow_pos()
	# but it should still be invisible at first
	$SelectedFoeArrow.visible = false
	
	# debug mode has win button
	if Debug.debug_mode:
		$WinButton.visible = true
	else:
		$WinButton.queue_free()
	
func toggle_lighting(node, choice):
	for N in node.get_children():
		if N.get_child_count() > 0:
#			print("["+N.get_name()+"]")
			toggle_lighting(N, choice)
		else:
			if N is Light2D:
				N.visible = choice

func update_chem_loadout():
	for c in $BattleChoices/Chemicals.get_children():
		c.queue_free()
	
	print(item_manager.loadout)
	for i in range(item_manager.loadout.size()):
		var chem_codename = item_manager.loadout[i]
		var chem_tube = load("res://Items/Chemicals/%s/%s.tscn" % [chem_codename, chem_codename])
		if not chem_tube:
			print("critical: %s.tscn does not exist." % chem_codename)
		chem_tube = chem_tube.instance()
		chem_tube.set_name(item_manager.loadout[i])
		chem_tube.position = Vector2(0, -27 + 35 * i)
		$BattleChoices/Chemicals.add_child(chem_tube)
	
	if $BattleChoices/Chemicals.get_child_count() > 0:
		selected_chem = 0
	else:
		selected_chem = null
	
func _process(delta):
	if state == PLAYER_TURN:
		get_move_choice()
	elif state == PLAYER_CHOOSE_ENEMY:
#		$SelectedFoeArrow.visible = true
		get_chem_choice()
		get_enemy_choice()
	elif state == ENEMY_TURN:
		start_dodge_game()
		
	elif state == DODGE_GAME:
		do_dodge_game()
	
		
func get_move_choice():
	if focused_menu == MENU:
		if not battle_choice_confirmed:
			if Input.is_action_just_pressed(player_up) or Input.is_action_just_pressed(player_down):
				if selected_battle_choice == "attack":
					selected_battle_choice = "item"
				else:
					selected_battle_choice = "attack"
		else:
			if selected_battle_choice == "attack":
				state = PLAYER_CHOOSE_ENEMY
				open_chems()
				
		if Input.is_action_just_pressed(player_confirm):
			focused_menu = INV if selected_battle_choice == "item" else focused_menu
			battle_choice_confirmed = true
			
			for foe in get_foes():
				foe.say_line()
			
		elif Input.is_action_just_pressed(player_cancel):
			battle_choice_confirmed = false
			$SelectedChemArrow.visible = false
	elif focused_menu == INV:
		focused_menu = MENU if not $InventoryMenu.visible else focused_menu

func get_chem_choice():
	# (a % b + b) % b
	# % is NOT modulo, it's REMAINDER!!!
	var b = item_manager.loadout.size()
	
	
	
	if Input.is_action_just_pressed(player_down):
		selected_chem = ((selected_chem+1) % b + b) % b
		set_arrow_pos() # to make the foe arrow invisible if need be
	elif Input.is_action_just_pressed(player_up):
		selected_chem = ((selected_chem-1) % b + b) % b
		set_arrow_pos() # to make the foe arrow invisible if need be
		
		
#	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up"):
		
	
	set_chem_arrow_pos()
	

func set_chem_arrow_pos():
	if selected_chem != null:
		$SelectedChemArrow.visible = true
		$SelectedChemArrow.position.x = 100
		$SelectedChemArrow/Tween.interpolate_property($SelectedChemArrow, "position:y",
			$SelectedChemArrow.position.y, $BattleChoices/Chemicals.get_child(selected_chem).get_global_transform()[2][1] - 22,
			0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$SelectedChemArrow/Tween.start()
	else:
		$SelectedChemArrow.visible = false

func get_enemy_choice():
	
	if Input.is_action_just_pressed(player_right):
			selected_foe = (selected_foe+1) % get_foes().size()
			set_arrow_pos()
			
	elif Input.is_action_just_pressed(player_left):
			selected_foe = (selected_foe-1) % get_foes().size()
			set_arrow_pos()
	
	# when going up or down we need to see if the arrow should be shown
#	if (Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down")
#			or Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right")):
#		selected_chem_category = $BattleChoices/Chemicals.get_child(selected_chem).category
#		print("category: %s" % selected_chem_category)
#		match selected_chem_category: # arrow's gonna disapear if you don't need it
#			OFFENSIVE:
#				print("shooouuuld be showimg the thing!")
#				$SelectedFoeArrow.visible = true
#			DEFENSIVE:
#				print("shooouuuld be hiding the thing!")
#				$SelectedFoeArrow.visible = false
	
	if Input.is_action_just_pressed(player_confirm):
		#attack()
		# ^ whoah WHOIOAH whOAH there bucko, we gotta fill green up first
		yield(get_tree().create_timer(0.01), "timeout")
		state = POURING
		start_pouring_event()
	elif Input.is_action_just_pressed(player_cancel):
		state = PLAYER_TURN
		$SelectedFoeArrow.visible = false
		battle_choice_confirmed = false
		close_chems()

func set_arrow_pos():
	if selected_foe != null:
		print("set_arrow_pos called")
		$SelectedFoeArrow.visible = true
		
		$SelectedFoeArrow/Tween.interpolate_property($SelectedFoeArrow, "position:x",
			$SelectedFoeArrow.position.x, get_foes()[selected_foe].position.x,
			0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
		# DONT FORGET TO START THE TWEEN U MORON!
		$SelectedFoeArrow/Tween.start()
		$SelectedFoeArrow.position.y = 64 
		
		selected_chem_category = $BattleChoices/Chemicals.get_child(selected_chem).category
		print("category: %s" % selected_chem_category)
		match selected_chem_category: # arrow's gonna disapear if you don't need it
			OFFENSIVE:
				print("shooouuuld be showimg the thing!")
				$SelectedFoeArrow.visible = true
			DEFENSIVE:
				print("shooouuuld be hiding the thing!")
				$SelectedFoeArrow.visible = false
	else:
		$SelectedFoeArrow.visible = false

func get_foes():
	return get_tree().get_nodes_in_group("foes")

func hurt(who, damage):
	damage = int(round(damage))
	var pstats = $"/root/PlayerStats"
	match who:
		"green":
			pstats.green_hp -= damage
			pstats.green_hp = clamp(pstats.green_hp, 0, 9999)
			$BattleChoices/GreenHPBar.update_bar()
			if has_node("DodgerField/dodge_circle/GreenHPBar"):
				$DodgerField/dodge_circle/GreenHPBar.update_bar()
				$DodgerField/DamageSound.play()
		"orange":
			pstats.orange_hp -= damage
			pstats.orange_hp = clamp(pstats.orange_hp, 0, 9999)
			$BattleChoices/OrangeHPBar.update_bar()
			if has_node("DodgerField/dodge_circle/OrangeHPBar"):
				$DodgerField/dodge_circle/OrangeHPBar.update_bar()
				$DodgerField/DamageSound.play()
		_:
			who.call("get_hurt", damage)
	if pstats.green_hp < 0 and pstats.orange_hp < 0:
		get_tree().change_scene_to(load("res://Rooms/Deadlands/Deadlands.tscn"))
#		exit_battle()
		
	print("%s took %s damage" % [who, damage])
	
func foe_died():
	print("something died, " + str(get_foes().size()) + " foes left")
	
	total_dollar_reward += int(get_foes()[selected_foe].dollar_reward * 0.85 + (randf() * 0.3))
	
	if get_foes().size()-1 != 0:
		selected_foe = (selected_foe - 1) % get_foes().size()
	else:
		state = WAIT
		$Win.start()
#		exit_battle()

func inflict_effect(who, eff):
#	print("who.has_node(eff.keys()[0]):%s"%who.has_node(eff.keys()[0]))
	var fx_name = eff.keys()[0]
	var fx_lvl = eff.values()[0]
	if fx_lvl <= 0: return # disallow 0
	
	if who.has_node(fx_name):
#		who.get_node(fx_name).remove()
		who.get_node(fx_name).name += "Removed"
		who.get_node(fx_name + "Removed").queue_free()
		remove_effect_icon(fx_name)
		
	var eff_scene = load("res://Engine/Battle/StatusEffects/%s.tscn" % eff.keys()[0]).instance()
	eff_scene.level = eff.values()[0]
	who.add_child(eff_scene)
	print("%s inflicted on %s!" % [eff_scene.name, who.name])
	
	if who == player_node:
		var new_icon_instance = new_effect_icon.instance()
		new_icon_instance.setup(fx_name, fx_lvl)
		$EffectsDisplay.add_child(new_icon_instance)
	
	

func remove_effect_icon(eff):
	var eff_icon_name = eff + "Icon"
	if $EffectsDisplay.has_node(eff_icon_name):
		# cause i was having trrouble with the next one being named differently
		# because of the node being removed the frame after the new one
		# is named
		var eff_icon_name_new = eff_icon_name + "Removed"
		$EffectsDisplay.get_node(eff_icon_name).name = eff_icon_name_new
		
		$EffectsDisplay.get_node(eff_icon_name_new).queue_free()

func open_chems():
	$SelectedChemArrow.visible = true
	set_arrow_pos()
	emit_signal("open_chems")

func close_chems():
	$SelectedChemArrow.visible = false
	emit_signal("close_chems")

func start_chem_attack():
	var chem_name = item_manager.loadout[selected_chem]
	var chem_object = $BattleChoices/Chemicals.get_child(selected_chem)
	if chem_object.category == chem_object.OFFENSE:
		var chem_splash = load("res://Items/Chemicals/%s/%s_splash.tscn" % [chem_name, chem_name])
		chem_splash = chem_splash.instance()
		chem_splash.position = get_foes()[selected_foe].position
		add_child(chem_splash)
	elif chem_object.category == chem_object.DEFENSE:
		var chem_visual = load("res://Items/Chemicals/%s/%s_visual.tscn" % [chem_name, chem_name])
		chem_visual = chem_visual.instance()
		chem_visual.position = $PouringEvent/FillingFlask.position
		add_child(chem_visual)
		
		# apply the defensive effect
		# todo, get the effect the proper way, like using the stuff from the \
		#  pourevent
		var gotten_effect = chem_object.get_effect()
		var effect_to_inflict = {gotten_effect.keys()[0]: \
				int(gotten_effect.values()[0] * $PouringEvent.output_effectiveness)}
		# change the strength of the effect using the output_effectiveness
		print("eeeeeeeeeeeeeeeeeeeeeeee")
		print($PouringEvent.output_effectiveness)
		print(effect_to_inflict.values()[0])
		
		
#		effect_to_inflict.values()[0] = int(effect_to_inflict.values()[0] * $PouringEvent.output_effectiveness)
		print("eeeeeeeeeeeeeeeeeeeeeeee")
		inflict_effect(player_node, effect_to_inflict) # fix get_effect
		# tmp down below
#		inflict_effect(player_node, {"Mundane" : 2}) 
		
		
		
func chem_hit_foe():
	print("wow you hit something")
	var chemical_node = $BattleChoices/Chemicals.get_child(selected_chem)
	chemical_node.fire(get_foes(), selected_foe, $PouringEvent.output_effectiveness)

func chem_anim_complete():
	state = WAIT
	$SelectedFoeArrow.visible = false
	battle_choice_confirmed = false
	$PouringEvent.reset()
	yield(get_tree().create_timer(0.5), "timeout")
	state = ENEMY_TURN

func start_pouring_event():
	#yield(get_tree().create_timer(0.1), "timeout")
	var pouring = get_node("PouringEvent")
#	pouring.visible = true
	close_chems()

func do_dodge_game():
	if $DodgerField.visible:
		$DodgerField.run()

func start_dodge_game():
	if get_foes().size() > 0:
		$DodgerField.visible = true
		$Tint.visible = true
		$DodgerField/AnimationPlayer.play("appear")
		
		# give some time for the show-up animation to finish
		yield(get_tree().create_timer(0.8), "timeout")
		
		state = DODGE_GAME

func end_dodge_game():
	$DodgerField.visible = false
	$Tint.visible = false
	state = PLAYER_TURN
	$DodgerField/AnimationPlayer.play_backwards("appear")
	# uh maybe this should move somewhere else at some point
	get_tree().call_group("status_effects", "do_effect")
	
	# every enemy alive has completed an attack
	for f in get_foes():
		f.attacks_completed += 1
	emit_signal("foe_attack_completed")
	
	# new turn
	next_player_turn()

func do_inventory():
	pass

func exit_battle():
	global.end_battle()
	$"/root/MusicManager".update_music("level")
	global.get_player().set_frozen(false, true)
	toggle_lighting(get_tree().get_current_scene(), true)
	
	# undo worldfoe changes
	for f in get_tree().get_nodes_in_group("WorldFoes"):
		f.speed /= 1.5
		f.follow_distance /= 2.0
		f.collision_mask = 32768 # (bit 15)

func next_player_turn():
	
	if PlayerStats.player_count == 1:
		return
	
	if whos_turn == 1:
		whos_turn = 2
		
		# change battle menu's material to be orange
		$BattleChoices.set_material($BattleChoices.ORANGE_MAT)
		
		$PouringEvent.swap_character_sprites(2)
		
		# change inputs to be 2P's
		# shut up!!!!
		player_up = "up2"
		player_down = "down2"
		player_left = "left2"
		player_right = "right2"
		player_confirm = "confirm2"
		player_cancel = "cancel2" 
		player_action = "action2"
		other_player_up = "up2"
		
		other_player_down = "down"
		other_player_left = "left"
		other_player_right = "right"
		other_player_confirm = "confirm"
		other_player_cancel = "cancel"
		other_player_action = "action"
	
	elif whos_turn == 2:
		whos_turn = 1
		
		# change battle menu's material to be green
		$BattleChoices.set_material($BattleChoices.GREEN_MAT)
		
		$PouringEvent.swap_character_sprites(1)
		
		player_up = "up"
		player_down = "down"
		player_left = "left"
		player_right = "right"
		player_confirm = "confirm"
		player_cancel = "cancel"
		player_action = "action"
		
		other_player_down = "down2"
		other_player_left = "left2"
		other_player_right = "right2"
		other_player_confirm = "confirm2"
		other_player_cancel = "cancel2"
		other_player_action = "action2"
	
	print("it's %s's turn now" % whos_turn)

func _on_WinButton_pressed():
	$Win.start()

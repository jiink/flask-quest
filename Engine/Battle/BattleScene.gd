extends Node

signal hit_foe

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
var focused_menu = MENU

var state = PLAYER_TURN
var selected_foe = 0
var selected_chem = 0

var selected_battle_choice = "attack"
var battle_choice_confirmed = false

onready var global = get_node("/root/global")
onready var item_manager = get_node("/root/ItemManager")

var foe = load("res://Engine/Battle/BaseFoe.tscn")

func _ready():
	connect("open_chems", $BattleChoices, "open_chems")
	connect("close_chems", $BattleChoices, "close_chems")
	
	
	print(global.initial_enemies)
	for i in range(global.initial_enemies.size()):
		var foe = load("res://NPC/" + global.initial_enemies[i] + "/" + global.initial_enemies[i] + "Foe.tscn")
		var foe_instance = foe.instance()
		foe_instance.set_name(global.initial_enemies[i])
		foe_instance.position.x = 80 * i + 140
		foe_instance.position.y = 128
		$Foes.add_child(foe_instance)
		
	global.current_enemies = global.initial_enemies
	
	# battle bg
	$BattleBG.texture = global.battle_bg
	
	# put down the chemicals
	update_chem_loadout()
		
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
		$SelectedFoeArrow.visible = true
		get_chem_choice()
		get_enemy_choice()
	elif state == ENEMY_TURN:
		start_dodge_game()
		
	elif state == DODGE_GAME:
		do_dodge_game()
	
		
func get_move_choice():
	if focused_menu == MENU:
		if not battle_choice_confirmed:
			if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
				if selected_battle_choice == "attack":
					selected_battle_choice = "item"
				else:
					selected_battle_choice = "attack"
		else:
			if selected_battle_choice == "attack":
				state = PLAYER_CHOOSE_ENEMY
				open_chems()
				
		if Input.is_action_just_pressed("a"):
			focused_menu = INV if selected_battle_choice == "item" else focused_menu
			battle_choice_confirmed = true
			
			for foe in get_foes():
				foe.say_line()
			
		elif Input.is_action_just_pressed("b"):
			battle_choice_confirmed = false
			$SelectedChemArrow.visible = false
	elif focused_menu == INV:
		focused_menu = MENU if not $InventoryMenu.visible else focused_menu

func get_chem_choice():
	# (a % b + b) % b
	# % is NOT modulo, it's REMAINDER!!!
	var b = item_manager.loadout.size()
	if Input.is_action_just_pressed("down"):
		selected_chem = ((selected_chem+1) % b + b) % b
		
	elif Input.is_action_just_pressed("up"):
		selected_chem = ((selected_chem-1) % b + b) % b
	
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
	
	if Input.is_action_just_pressed("right"):
			selected_foe = (selected_foe+1) % get_foes().size()
			
	elif Input.is_action_just_pressed("left"):
			selected_foe = (selected_foe-1) % get_foes().size()
	
	set_arrow_pos()
	
	if Input.is_action_just_pressed("a"):
		#attack()
		# ^ whoah WHOIOAH whOAH there bucko, we gotta fill green up first
		yield(get_tree().create_timer(0.01), "timeout")
		state = POURING
		start_pouring_event()
	elif Input.is_action_just_pressed("b"):
		state = PLAYER_TURN
		$SelectedFoeArrow.visible = false
		battle_choice_confirmed = false
		close_chems()

func set_arrow_pos():
	if selected_foe != null:
		$SelectedFoeArrow.visible = true
		
		$SelectedFoeArrow/Tween.interpolate_property($SelectedFoeArrow, "position:x",
			$SelectedFoeArrow.position.x, get_foes()[selected_foe].position.x,
			0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
		# DONT FORGET TO START THE TWEEN U MORON!
		$SelectedFoeArrow/Tween.start()
		$SelectedFoeArrow.position.y = 64 
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
			$DodgerField/dodge_circle/GreenHPBar.update_bar()
		"orange":
			pstats.orange_hp -= damage
			pstats.orange_hp = clamp(pstats.orange_hp, 0, 9999)
			$BattleChoices/OrangeHPBar.update_bar()
			$DodgerField/dodge_circle/OrangeHPBar.update_bar()
		_:
			who.call("get_hurt", damage)
	if pstats.green_hp < 0 and pstats.orange_hp < 0:
		get_tree().change_scene_to(load("res://Rooms/Deadlands/Deadlands.tscn"))
		exit_battle()
		
	print("%s took %s damage" % [who, damage])
	
func foe_died():
	print("something died, " + str(get_foes().size()) + " foes left")
	if get_foes().size()-1 != 0:
		selected_foe = (selected_foe - 1) % get_foes().size()
	else:
		exit_battle()

func inflict_effect(who, eff):
#	print("who.has_node(eff.keys()[0]):%s"%who.has_node(eff.keys()[0]))
	var fx_name = eff.keys()[0]
	var fx_lvl = eff.values()[0]
	
	if who.has_node(fx_name):
		who.get_node(fx_name).remove()
		
	var eff_scene = load("res://Engine/Battle/StatusEffects/%s.tscn" % eff.keys()[0]).instance()
	eff_scene.level = eff.values()[0]
	who.add_child(eff_scene)
	print("%s inflicted on %s!" % [eff_scene.name, who.name])
	
func open_chems():
	$SelectedChemArrow.visible = true
	emit_signal("open_chems")

func close_chems():
	$SelectedChemArrow.visible = false
	emit_signal("close_chems")

func start_chem_attack():
	var chem_splash = load("res://Items/Chemicals/%s/%s_splash.tscn" % [item_manager.loadout[selected_chem], item_manager.loadout[selected_chem]])
	chem_splash = chem_splash.instance()
	chem_splash.position = get_foes()[selected_foe].position
	add_child(chem_splash)

func chem_hit_foe():
	print("wow you hit something")
	var chemical_node = $BattleChoices/Chemicals.get_child(selected_chem)
	chemical_node.do_thing(get_foes(), selected_foe, $PouringEvent.effectiveness)

func chem_anim_complete():
	state = WAIT
	$SelectedFoeArrow.visible = false
	battle_choice_confirmed = false
	$PouringEvent.reset()
	yield(get_tree().create_timer(0.8), "timeout")
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
	$DodgerField.visible = true
	$Tint.visible = true
	$DodgerField/AnimationPlayer.play("appear")
	state = DODGE_GAME

func end_dodge_game():
	$DodgerField.visible = false
	$Tint.visible = false
	state = PLAYER_TURN
	$DodgerField/AnimationPlayer.play_backwards("appear")
	# uh maybe this should move somewhere else at some point
	get_tree().call_group("status_effects", "do_effect")

func do_inventory():
	pass

func exit_battle():
	global.end_battle()
	$"/root/MusicManager".update_music("level")
	pass
	
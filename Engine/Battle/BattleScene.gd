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
	DODGE_GAME
}
	



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
	
	
	#
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
	print(item_manager.loadout)
	for i in range(item_manager.loadout.size()):
		var chem_tube = load("res://Items/Chemicals/%s.tscn" % item_manager.loadout[i])
		chem_tube = chem_tube.instance()
		chem_tube.set_name(item_manager.loadout[i])
		chem_tube.position = Vector2(0, -27 + 35 * i)
		$BattleChoices/Chemicals.add_child(chem_tube)
		
func _process(delta):
	if state == PLAYER_TURN:
		get_move_choice()
	elif state == PLAYER_CHOOSE_ENEMY:
		$SelectedFoeArrow.visible = true
		get_chem_choice()
		get_enemy_choice()
	elif state == ENEMY_TURN:
		
#		match int(randf() * 2):
#			0:
#				hurt("green", 23)
#				if $"/root/PlayerStats".green_hp < 0:
#					hurt("orange", 23)
#			1:
#				hurt("orange", 23)
#				if $"/root/PlayerStats".orange_hp < 0:
#					hurt("green", 23)
#			_:
#				hurt("green", 23)
#
#		state = PLAYER_TURN
		
#		var dodger_field = load("res://Engine/Battle/Dodger/DodgerField.tscn")
#		dodger_field = dodger_field.instance()
#		dodger_field.set_position(Vector2(192, 108))
#		add_child(dodger_field)

		$DodgerField.visible = true
		$Tint.visible = true
		state = DODGE_GAME
		
	elif state == DODGE_GAME:
		do_dodge_game()
		
func get_move_choice():
#	if Input.is_action_just_pressed("a"):
#		state = PLAYER_CHOOSE_ENEMY
#	elif Input.is_action_just_pressed("b"):
#		exit_battle()
	if not battle_choice_confirmed:
		if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
			if selected_battle_choice == "attack":
				selected_battle_choice = "item"
			else:
				selected_battle_choice = "attack"
	else:
		if selected_battle_choice == "attack":
			#get_chem_choice()
			state = PLAYER_CHOOSE_ENEMY
			open_chems()
			
	if Input.is_action_just_pressed("a"):
#		if not battle_choice_confirmed and selected_battle_choice == "attack":
#			emit_signal("chems_popout")
		battle_choice_confirmed = true
	elif Input.is_action_just_pressed("b"):
#		if battle_choice_confirmed and selected_battle_choice == "attack":
#			emit_signal("chems_popin")
			
		battle_choice_confirmed = false
		$SelectedChemArrow.visible = false

func get_chem_choice():
	# (a % b + b) % b
	# % is NOT modulo, it's REMAINDER!!!
	var b = item_manager.loadout.size()
	if Input.is_action_just_pressed("down"):
		selected_chem = ((selected_chem+1) % b + b) % b
		
	elif Input.is_action_just_pressed("up"):
		selected_chem = ((selected_chem-1) % b + b) % b
	
	set_chem_arrow_pos()
	
#	if Input.is_action_just_pressed("a"):
#		state = PLAYER_CHOOSE_ENEMY
		#state = "attacking"

func set_chem_arrow_pos():
	if selected_chem != null:
		$SelectedChemArrow.visible = true
		$SelectedChemArrow.position.x = 100
		#$SelectedChemArrow.position.y = $BattleChoices/Chemicals.get_child(selected_chem).get_global_transform()[2][1] - 22 
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
		#state = "attacking"

func set_arrow_pos():
	if selected_foe != null:
		$SelectedFoeArrow.visible = true
		#$SelectedFoeArrow.position.x = get_foes()[selected_foe].position.x
		
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
	var pstats = $"/root/PlayerStats"
	match who:
		"green":
			pstats.green_hp -= damage
			$BattleChoices/GreenHPBar.update_bar()
		"orange":
			pstats.orange_hp -= damage
			$BattleChoices/OrangeHPBar.update_bar()
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

func open_chems():
	$SelectedChemArrow.visible = true
	emit_signal("open_chems")

func close_chems():
	$SelectedChemArrow.visible = false
	emit_signal("close_chems")

func start_chem_attack():
	var chem_splash = load("res://Items/Chemicals/%s_splash.tscn" % item_manager.loadout[selected_chem])
	chem_splash = chem_splash.instance()
	chem_splash.position = get_foes()[selected_foe].position
	add_child(chem_splash)

func chem_hit_foe():
	print("wow you hit something")
	
	hurt(get_foes()[selected_foe], 
			int(int(item_manager.items[item_manager.loadout[selected_chem]].damage) * $PouringEvent.effectiveness))

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
	pouring.visible = true
	close_chems()

func do_dodge_game():
	if $DodgerField.visible:
		$DodgerField.run()

func exit_battle():
	global.end_battle()
	pass
	
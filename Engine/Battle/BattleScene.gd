extends Node

signal hit_foe

var state = "player turn"
var selected_foe = 0
var selected_chem = 0

var selected_battle_choice = "attack"
var battle_choice_confirmed = false

onready var global = get_node("/root/global")
onready var item_manager = get_node("/root/ItemManager")

var foe = load("res://Engine/Battle/BaseFoe.tscn")

func _ready():
	
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
	if state == "player turn":
		get_move_choice()
	elif state == "player choose enemy":
		$SelectedFoeArrow.visible = true
		get_enemy_choice()

func get_move_choice():
#	if Input.is_action_just_pressed("a"):
#		state = "player choose enemy"
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
			get_chem_choice()
	if Input.is_action_just_pressed("a"):
#		if selected_battle_choice == "attack":
#			state = "player choose chemical"
#		elif selected_battle_choice == "item":
#			state = "player choose item"
		
		battle_choice_confirmed = true
	elif Input.is_action_just_pressed("b"):
		battle_choice_confirmed = false

func get_chem_choice():
	# (a % b + b) % b
	# % is NOT modulo, it's REMAINER!!!
	var b = item_manager.loadout.size()
	if Input.is_action_just_pressed("down"):
		selected_chem = ((selected_chem+1) % b + b) % b
		
	elif Input.is_action_just_pressed("up"):
		selected_chem = ((selected_chem-1) % b + b) % b
	
	set_chem_arrow_pos()
	
	if Input.is_action_just_pressed("a"):
		state = "player choose enemy"
		#state = "attacking"

func set_chem_arrow_pos():
	if selected_chem != null:
		$SelectedChemArrow.visible = true
		$SelectedChemArrow.position.x = 100
		$SelectedChemArrow.position.y = $BattleChoices/Chemicals.get_child(selected_chem).get_global_transform()[2][1] - 22 
	else:
		$SelectedChemArrow.visible = false

func get_enemy_choice():
	
	if Input.is_action_just_pressed("right"):
			selected_foe = (selected_foe+1) % get_foes().size()
			
	elif Input.is_action_just_pressed("left"):
			selected_foe = (selected_foe-1) % get_foes().size()
	
	set_arrow_pos()
	
	if Input.is_action_just_pressed("a"):
		attack()
		#state = "attacking"

func set_arrow_pos():
	if selected_foe != null:
		$SelectedFoeArrow.visible = true
		$SelectedFoeArrow.position.x = get_foes()[selected_foe].position.x
		$SelectedFoeArrow.position.y = 64 
	else:
		$SelectedFoeArrow.visible = false

func get_foes():
	return get_tree().get_nodes_in_group("foes")

func attack():
	print("attaaaack " + get_foes()[selected_foe].name)
	get_foes()[selected_foe].call("get_hurt", 20)
	#emit_signal("hit_foe", get_tree().get_nodes_in_group("foes")[i])
	
	#selected_foe = null
	$SelectedFoeArrow.visible = false
	state = "player turn"
	
func foe_died():
	print("something died, " + str(get_foes().size()) + " foes left")
	if get_foes().size()-1 != 0:
		selected_foe = (selected_foe - 1) % get_foes().size()
	else:
		exit_battle()

func exit_battle():
	global.end_battle()
	pass
	
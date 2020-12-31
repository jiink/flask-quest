extends Node

signal scene_changed
signal battle_won

const ORANGE_COLOR = Color("f68f31")
const GREEN_COLOR = Color("72d031")
const SAVE_KEY = "global_"

enum Direction { UP, RIGHTUP, RIGHT, RIGHTDOWN, DOWN, LEFTDOWN, LEFT, LEFTUP }

# player vars
var player_hp = 100

func get_player(num = 1):
	var player_names = ["Player", "Orange", "Ribbit"]
	var player_search_name = player_names[num-1]
	if get_tree().get_current_scene().has_node("YSort/%s" % player_search_name):
		return get_tree().get_current_scene().get_node("YSort/%s" % player_search_name)
	# if that doesn't work try the other way :(
	for n in get_tree().get_nodes_in_group("Player"):
		if n.name == player_search_name:
			return n

	print("couldn't get_player #%s" % num)

	return null

func get_players():
	return [get_player(1), get_player(2)]

func freeze_all_players(setting = true):
	var p = get_player()
	if p:
		p.set_frozen(setting, true)
	else:
		print("couldn't freeze all players")

################## battle ##################

# battle vars
var initial_enemies = []
var current_enemies = initial_enemies
var battle_bg
var prev_scene = null
var in_battle = false

var center = Vector2(384/2, 216/2)

func custompause(node, x):
	x = !x
	for N in node.get_children():
		if N.get_child_count() > 0:
			N.set_process(x)
			# N.set_process_internal(x) # this makes the game break!
			N.set_process_input(x)
			N.set_physics_process(x)
			custompause(N, !x)
		else:
			N.set_process(x)
			# N.set_process_internal(x)
			N.set_process_input(x)
			N.set_physics_process(x)
#			print("- "+N.get_name())

func start_battle(foes):
	print("starting a battle?")
	# if you seriously don't have any chemicals, you just get hurt
	# check if you have chemicals
	var has_any_chemicals = false
	if ItemManager.loadout.size() > 0:
		has_any_chemicals = true
	else:
		# check the inventory
		for item in ItemManager.inventory:
			if ItemManager.items[item].has("equippable") and (ItemManager.items[item])["equippable"]:
				has_any_chemicals =  true
				break
	if not has_any_chemicals:
		print("YOU HAVE NO CHEMICALS GET HURT !!")
		var p = get_player()
		if p:
			p.do_floaty_text("owch")
			PlayerStats.green_hp -= 15
		## done with function ##
		return

	# --- usual case: player has chemicals and a battle actually starts -- ##
	
	get_player().frozen = true
	
	var hud = get_tree().get_current_scene().get_node("HUD")
	
	if not hud.has_node("BattleStartTransition"):
		print("hud doesnt have battle transition")
		initial_enemies = foes
		var battle_start_transition = preload("res://Engine/Battle/BattleStartTransition.tscn").instance()
		hud.add_child(battle_start_transition)
	
		# alert surround foes!
		for f in get_tree().get_nodes_in_group("WorldFoes"):
			f.set_rush(true)
			
	else:
		for n in foes:
			initial_enemies.append(n)
		in_battle = true

func get_dodger(which_player): # 1 for green, 2 for oragne
	var player_name
	match which_player:
		1:
			player_name = "Green"
		2:
			player_name = "Orange"
		_:
			print("warning: called get_dodger with a %s" % player_name)
			
	if get_tree().get_current_scene().name == "AttackTestingField":
		return get_tree().get_current_scene().get_node("%sPawn/Sprite" % player_name)
		
	if get_tree().get_current_scene().has_node("BattleScene/DodgerField/%sPawn/Sprite" % player_name):
		return get_tree().get_current_scene().get_node("BattleScene/DodgerField/%sPawn/Sprite" % player_name)
	else:
		print("Couldn't get the %s dodger!" % player_name)
		return null
		

func get_battle_scene():
	if get_tree().get_current_scene().has_node("BattleScene"):
		return get_tree().get_current_scene().get_node("BattleScene");
	return null
	
#	initial_enemies = ["Boque", "Boque", "Boque"]
	#print(get_tree().get_current_scene())
	#print(get_tree().get_current_scene().get_path())
#	prev_scene = (str(get_tree().get_current_scene().get_path()) + ".tscn").replace("/root", "res:/")
#
#	var battle_scene = load("res://Engine/Battle/BattleScene.tscn").instance()
#
#
#	get_tree().get_current_scene().get_node("Camera").current = false
#	#get_tree().paused = true
#
#	custompause(get_tree().get_current_scene(), true)
#
#	for child in get_tree().get_current_scene().get_children():
#		if not child.get("visible") == null:
#			child.visible = false
#
#
#	get_tree().get_current_scene().add_child(battle_scene)
#
#	get_tree().get_current_scene().get_node("BattleScene/Camera").current = true
#
	
	#print("after battle start: %s" % get_tree().get_current_scene().get_children())
	
	#broken
	#get_tree().get_root().add_child(battle_scene)
	
	#prev_scene = load(get_tree().get_current_scene().filename)
	#print(prev_scene)
	#get_tree().change_scene("res://Engine/Battle/BattleScene.tscn")
	#get_tree().get_root().remove_child(prev_scene)

func end_battle():
	get_tree().get_current_scene().get_node("BattleScene").queue_free()
	
	get_tree().get_current_scene().get_node("Camera").current = true
	
	custompause(get_tree().get_current_scene(), false)
	
	for child in get_tree().get_current_scene().get_children():
		if child.get("visible") != null:
			child.visible = true
	
	get_player().go_invincible(3.0)
	
	in_battle = false
	
	
	emit_signal("battle_won")
	
################## scene ##################

var player_new_position
var next_scene
var next_player_position
var next_player_direction

enum StartingDirection { NONE, UP, RIGHTUP, RIGHT, RIGHTDOWN, DOWN, LEFTDOWN, LEFT, LEFTUP }

#signal transition_close

onready var game_saver = get_node("/root/GameSaver")

func _ready():
	# jumble em up
	randomize()
	
	# change background color
	VisualServer.set_default_clear_color(Color("0e111c"))
#	connect_to_transition()
	#(#get_tree().get_nodes_in_group("Camera")[0].get_node("../HUD/SceneTransition"), "fade_out")
	
	
	
	# apply input config. from inputconfigmenu.gd lol
	
	var INPUT_ACTIONS = [ "up", "down", "left", "right", "confirm", "cancel", "action", "special" ]
	var CONFIG_FILE = "user://input.cfg"
	
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err:
		for action_name in INPUT_ACTIONS:
			var action_list = InputMap.get_action_list(action_name)
			if action_list[0].get("scancode") != null: # gamepads dont have scancodes
				var scancode = OS.get_scancode_string(action_list[0].scancode)
				config.set_value("input", action_name, scancode)
		config.save(CONFIG_FILE)
	else:
		for action_name in config.get_section_keys("input"):
			var scancode = OS.find_scancode_from_string(config.get_value("input", action_name))
			var event = InputEventKey.new()
			event.scancode = scancode
			
			for old_event in InputMap.get_action_list(action_name):
				if old_event is InputEventKey:
					InputMap.action_erase_event(action_name, old_event)
			InputMap.action_add_event(action_name, event)
	#### set ui controls
	# p1
	copy_actions("up", "ui_up")
	copy_actions("down", "ui_down")
	copy_actions("left", "ui_left")
	copy_actions("right", "ui_right")
	
	copy_actions("confirm", "ui_accept")
	copy_actions("confirm", "ui_select")
	copy_actions("cancel", "ui_cancel")
	
	# p2
	copy_actions("up2", "ui_up")
	copy_actions("down2", "ui_down")
	copy_actions("left2", "ui_left")
	copy_actions("right2", "ui_right")
	
	copy_actions("confirm2", "ui_accept")
	copy_actions("confirm2", "ui_select")
	copy_actions("cancel2", "ui_cancel")

func copy_actions(from, to):
	for event in InputMap.get_action_list(from):
		InputMap.action_add_event(to, event)

func start_scene_switch(new_scene, new_player_position, new_player_direction = StartingDirection.NONE):
	# save!!!
	game_saver.save()
	
	print("changing scenes to %s..." % new_scene)
	next_scene = new_scene
	next_player_position = new_player_position
	if typeof(new_player_direction) == TYPE_INT:
		next_player_direction = new_player_direction
	else:
		print("new_player_direction isn't an INT")

#	emit_signal("transition_close")
	# show a transition if possible
	if get_tree().get_current_scene().has_node("HUD/SceneTransition"):
		get_tree().get_current_scene().get_node("HUD/SceneTransition").fade_out()
	else:
		swap_scenes()
	

func swap_scenes():
	print("about to do change_scene(%s)" % next_scene)
	get_tree().change_scene(next_scene)
	
	yield(get_tree().create_timer(0.01), "timeout")
#	connect_to_transition()
	if next_player_position != null:
		for p in get_tree().get_nodes_in_group("Player"):
			p.position = next_player_position
			if next_player_direction != null and next_player_direction != StartingDirection.NONE:
				p.direction = next_player_direction
	else:
		print("warning: new player pos is null")
	
	# janky problems need janky solutions
	if get_player(1):
		get_player(1).clear_history()
	
	PlayerStats.set_player_num(PlayerStats.player_count)

	emit_signal("scene_changed")
	# load!!
	
#	game_saver.load(1)

#func connect_to_transition():
#	if get_tree().get_current_scene().has_node("HUD/SceneTransition"):
#		connect("transition_close", get_tree().get_current_scene().get_node("HUD/SceneTransition"), "fade_out")
#	else:
#		print("Couldn't do scene transition")

################# misc #####################

var event_seed = 0

func get_camera():
	return get_tree().get_current_scene().get_node("Camera")

func get_hud():
	if get_tree().get_current_scene().has_node("HUD"):
		return get_tree().get_current_scene().get_node("HUD")
	return null

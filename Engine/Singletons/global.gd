extends Node

signal scene_changed
signal battle_won

# player vars
var player_hp = 100

func get_player():
	if get_tree().get_nodes_in_group("Player"):
		return get_tree().get_nodes_in_group("Player")[0]
	else:
		return null
	
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
			N.set_process_internal(x)
			N.set_process_input(x)
			N.set_process_internal(x)
			N.set_physics_process(x)
			custompause(N, !x)
		else:
			N.set_process(x)
			N.set_process_internal(x)
			N.set_process_input(x)
			N.set_process_internal(x)
			N.set_physics_process(x)
#			print("- "+N.get_name())

func start_battle(foes):
	get_player().frozen = true
	
	var hud = get_tree().get_current_scene().get_node("HUD")
	
	if not hud.has_node("BattleStartTransition"):
		initial_enemies = foes
		var battle_start_transition = preload("res://Engine/Battle/BattleStartTransition.tscn").instance()
		hud.add_child(battle_start_transition)
	
		for f in get_tree().get_nodes_in_group("WorldFoes"):
			f.speed *= 1.5
			f.follow_distance *= 1.5
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
		return get_tree().get_current_scene().get_node("Dodgers/%sSprite" % player_name)
		
	if get_tree().get_current_scene().has_node("BattleScene/DodgerField/Dodgers/%sSprite" % player_name):
		return get_tree().get_current_scene().get_node("BattleScene/DodgerField/Dodgers/%sSprite" % player_name)
	else:
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
	
	custompause(get_tree().get_current_scene(), false)
	
	for child in get_tree().get_current_scene().get_children():
		if not child.get("visible") == null:
			child.visible = true
	
	get_player().go_invincible(3.0)
	
	in_battle = false
	
	get_tree().get_current_scene().get_node("Camera").current = true
	
	emit_signal("battle_won")
	
################## scene ##################

var player_new_position
var next_scene
var next_player_position

#signal transition_close

onready var game_saver = get_node("/root/GameSaver")

func _ready():
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
	
func start_scene_switch(new_scene, new_player_position):
	# save!!!
	game_saver.save(1) # todo: slot changing
	
	print("changing scenes to %s..." % new_scene)
	next_scene = new_scene
	next_player_position = new_player_position
	
#	emit_signal("transition_close")
	if get_tree().get_current_scene().has_node("HUD/SceneTransition"):
		get_tree().get_current_scene().get_node("HUD/SceneTransition").fade_out()
	

func swap_scenes():
	print("about to do change_scene(%s)" % next_scene)
	get_tree().change_scene(next_scene)
	
	yield(get_tree().create_timer(0.01), "timeout")
#	connect_to_transition()
	if next_player_position != null:
		get_tree().get_nodes_in_group("Player")[0].position = next_player_position
	else:
		print("warning: new player pos is null")
	
	emit_signal("scene_changed")
	# load!!
	
#	game_saver.load(1)

#func connect_to_transition():
#	if get_tree().get_current_scene().has_node("HUD/SceneTransition"):
#		connect("transition_close", get_tree().get_current_scene().get_node("HUD/SceneTransition"), "fade_out")
#	else:
#		print("Couldn't do scene transition")
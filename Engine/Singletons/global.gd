extends Node

# player vars
var player_hp = 100
func get_player():
	return get_tree().get_nodes_in_group("Player")[0]
	
################## battle ##################

# battle vars
var initial_enemies = []
var current_enemies = initial_enemies
var battle_bg
var prev_scene = null

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
			f.speed = 90
			f.follow_distance *= 1.5
	else:
		for n in foes:
			initial_enemies.append(n)
	
	



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

################## scene ##################

var player_new_position
var next_scene
var next_player_position

signal transition_close

onready var game_saver = get_node("/root/GameSaver")

func _ready():
	connect_to_transition()
	#(#get_tree().get_nodes_in_group("Camera")[0].get_node("../HUD/SceneTransition"), "fade_out")

func start_scene_switch(new_scene, new_player_position):
	# save!!!
	game_saver.save(0) # todo: slot changing
	
	print("changing scenes")
	next_scene = new_scene
	next_player_position = new_player_position
	emit_signal("transition_close")
	
	

func swap_scenes():
	get_tree().change_scene(next_scene)
	
	yield(get_tree().create_timer(0.01), "timeout")
	connect_to_transition()
	if next_player_position != null:
		get_tree().get_nodes_in_group("Player")[0].position = next_player_position
	else:
		print("warning: new player pos is null")
	
	# load!!
	
	game_saver.load(0)

func connect_to_transition():
	if get_tree().get_current_scene().has_node("HUD/SceneTransition"):
		connect("transition_close", get_tree().get_current_scene().get_node("HUD/SceneTransition"), "fade_out")
	else:
		print("Couldn't do scene transition")
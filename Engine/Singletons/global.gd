extends Node

# player vars
var player_hp = 100

################## battle ##################

# battle vars
var initial_enemies = []
var current_enemies = initial_enemies
var battle_bg
var prev_scene = null

func start_battle(foes):
	initial_enemies = ["Boque", "Boque", "Boque"]
	#print(get_tree().get_current_scene())
	#print(get_tree().get_current_scene().get_path())
#	prev_scene = (str(get_tree().get_current_scene().get_path()) + ".tscn").replace("/root", "res:/")
	
	var battle_scene = load("res://Engine/Battle/BattleScene.tscn")
	
	#broken
	#get_tree().get_root().add_child(battle_scene)
	
	prev_scene = load(get_tree().get_current_scene().filename)
	print(prev_scene)
	#get_tree().change_scene("res://Engine/Battle/BattleScene.tscn")
	get_tree().get_root().remove_child(prev_scene)


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
	connect("transition_close", get_tree().get_current_scene().get_node("HUD/SceneTransition"), "fade_out")
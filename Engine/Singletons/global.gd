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
	get_tree().get_root().add_child(battle_scene)
	
	prev_scene = load(get_tree().get_current_scene().filename)
	print(prev_scene)
	#get_tree().change_scene("res://Engine/Battle/BattleScene.tscn")
	get_tree().get_root().remove_child(prev_scene)


################## scene ##################

var player_new_position

func switch_scenes(new_scene, new_player_position):
	print("changing scenes")
	get_tree().change_scene(new_scene)
	
	yield(get_tree().create_timer(0.01), "timeout")
	
	if new_player_position != null:
		get_tree().get_nodes_in_group("Player")[0].position = new_player_position
	else:
		print("warning: new player pos is null")
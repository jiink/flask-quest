extends Node

# player vars
var player_hp = 100

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
	prev_scene = get_tree().get_current_scene().filename
	print(prev_scene)
	get_tree().change_scene("res://Engine/Battle/BattleScene.tscn")
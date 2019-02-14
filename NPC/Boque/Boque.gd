extends Node2D

signal talk(obj)

func _ready():
	connect("talk", get_owner().get_node("HUD/Diag"), "start_talk")
	
func interact():
	emit_signal("talk", self)
	
func test_react():
	print("AAAA TEST REACT")
	
func test_react2(foo, x, y):
	print(foo + str(x + y))
	
func enter_battle():
	print("battle time")
	get_node("/root/global").start_battle(["Boque", "Boque", "Boque"])
	#get_node("/root/global").initial_enemies = ["Boque", "Boque", "Boque"]
	#get_tree().change_scene("res://Engine/Battle/BattleScene.tscn")
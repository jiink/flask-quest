extends Node2D

var x = 0

signal talk(obj)

func _ready():
	connect("talk", get_owner().get_node("HUD/Diag"), "start_talk")
	
func interact():
	emit_signal("talk", self)
	
func test_react(foo, x, y):
	print(foo + str(x + y))
	
	
func enter_battle():
	print("battle time")
	get_tree().change_scene("res://Engine/Battle/BattleScene.tscn")
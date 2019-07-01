extends Node2D

	
func interact():
	DiagHelper.start_talk(self)
	
func test_react():
	print("~~~~~~~~AAAA TEST REACT~~~~~~~~")
	
func test_react2(foo, x, y):
	print(foo + str(x + y))
	
func enter_battle(foes):
	if foes != null:
		get_node("/root/global").start_battle(foes)
	else:
		get_node("/root/global").start_battle(["Boque"])
	#get_node("/root/global").initial_enemies = ["Boque", "Boque", "Boque"]
	#get_tree().change_scene("res://Engine/Battle/BattleScene.tscn")
	print("battle time")
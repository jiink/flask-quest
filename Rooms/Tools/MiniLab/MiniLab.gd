# a minilab is a place where you can use the ingredients from your ingredient bag to make 
#  new chemicals. this object summons the MiniLabUI.
extends Node2D

var ui = preload("res://Rooms/Tools/MiniLab/MiniLabUI.tscn")

func interact():
	if ItemManager.ingredient_bag.size() <= 0:
		global.get_player().do_floaty_text("Useless...")
	else:
		var ui_instance = ui.instance()
		if global.get_hud() != null:
			global.get_hud().add_child(ui_instance)

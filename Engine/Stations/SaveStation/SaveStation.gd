extends Sprite

var save_menu = load("res://Engine/Stations/SaveStation/SaveMenu.tscn")

func interact():
	var save_menu_instance = save_menu.instance()
	get_owner().get_node("HUD").add_child(save_menu_instance)
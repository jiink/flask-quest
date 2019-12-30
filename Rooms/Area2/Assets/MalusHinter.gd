extends "res://Engine/BasicNPC.gd"

func give_credentials():
	ItemManager.give_item("map_login")
	
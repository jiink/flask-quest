extends "res://NPC/NPCBasic/NPCBasic.gd"

func give_hot_dog():
	if PlayerStats.dollars >= 3:
		ItemManager.give_ingredient("hot_dog")
		PlayerStats.dollars -= 3

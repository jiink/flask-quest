extends "res://NPC/NPCBasic/NPCBasic.gd"

func give_hot_dog():
	yield(get_tree().create_timer(0.1), "timeout")
	if PlayerStats.dollars >= 3:
		ItemManager.give_ingredient("hot_dog")
		PlayerStats.dollars -= 3
		DiagHelper.start_talk(self, "Successful")
	elif PlayerStats.dollars < 3:
		DiagHelper.start_talk(self, "NoMoney")

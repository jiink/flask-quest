extends "res://NPC/NPCBasic/NPCBasic.gd"

func interact():
	if not ("map_login" in ItemManager.inventory):
		DiagHelper.start_talk(self, "ToGiveCreds")
	else:
		DiagHelper.start_talk(self, "AlreadyHasCreds")

func give_credentials():
	ItemManager.give_item("map_login")
	

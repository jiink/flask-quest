extends "res://NPC/NPCBasic/NPCBasic.gd"

onready var dubble = get_node("../Dubble")

func interact():
	if not dubble:
		return
	
	if dubble.current_mission < dubble.Missions.BOMB_REMINDER:
		DiagHelper.start_talk(self, "PreMission")
	elif (dubble.current_mission == dubble.Missions.BOMB_REMINDER) and not \
	ItemManager.inventory.has("glasstown_bomb_item"):
		DiagHelper.start_talk(self, "Mission")
	elif (dubble.current_mission > dubble.Missions.BOMB_REMINDER):
		DiagHelper.start_talk(self, "LaterMission")
	elif (dubble.current_mission == dubble.Missions.BOMB_REMINDER) and \
	ItemManager.inventory.has("glasstown_bomb_item"):
		DiagHelper.start_talk(self, "PostMission")


func give_bomb():
	ItemManager.give_item("glasstown_bomb_item")

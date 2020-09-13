extends "res://NPC/NPCWalking/NPCWalking.gd"

onready var dubble = get_node("../Dubble")

func interact():
	if dubble.current_mission < dubble.Missions.GLITTER:
		DiagHelper.start_talk(self, "PreMission")
	elif (dubble.current_mission == dubble.Missions.GLITTER_REMINDER) and not \
	ItemManager.inventory.has("glitter_item"):
		DiagHelper.start_talk(self, "Mission")
	elif (dubble.current_mission > dubble.Missions.GLITTER_REMINDER):
		DiagHelper.start_talk(self, "LaterMission")
	elif (dubble.current_mission == dubble.Missions.GLITTER_REMINDER) and \
	ItemManager.inventory.has("glitter_item"):
		DiagHelper.start_talk(self, "PostMission")
func give_glitter():
	ItemManager.give_item("glitter_item")

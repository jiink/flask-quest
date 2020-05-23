extends Node2D

var already_started = false

func interact():
	print(get_owner().lab_door_open)
	if not get_owner().lab_door_open:
		if ItemManager.inventory.has("miniman_item") or ItemManager.loadout.has("miniman_item"):
			if not already_started:
				DiagHelper.start_talk(self, "IfYesMiniman")
		else:
			DiagHelper.start_talk(self, "IfNoMiniman")

func toss_miniman():
	print("OK OK OK OK OK OK ok miniman miniman lets pretend miniman was thrown")
	already_started = true
	get_owner().get_node("MinimanDoorEvent").start_event()
#	ItemManager.inventory.remove("miniman_item")
#	get_owner().lab_door_open = true
#	get_owner().update_lab_door()

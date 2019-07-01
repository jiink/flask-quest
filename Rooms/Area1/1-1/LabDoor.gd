extends Node2D

func interact():
	
	if not get_owner().lab_door_open:
		if ItemManager.inventory.has("miniman_item"):
			DiagHelper.start_talk(self, "IfYesMiniman")
		else:
			DiagHelper.start_talk(self, "IfNoMiniman")

func toss_miniman():
	print("OK OK OK OK OK OK ok miniman miniman lets pretend miniman was thrown")
	ItemManager.inventory.remove("miniman_item")
	get_owner().lab_door_open = true
	get_owner().update_lab_door()
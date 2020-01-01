extends "res://Engine/BasicNPC.gd"

func interact():
	if get_owner().ready_to_ask_for_keycard:
		DiagHelper.start_talk(self, "GoAway")
	else:
		DiagHelper.start_talk(self, "Welcome")

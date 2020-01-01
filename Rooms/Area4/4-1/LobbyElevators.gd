extends "res://Engine/BasicNPC.gd"

func become_ready_for_keycard_asking():
	get_owner().ready_to_ask_for_keycard = true
extends "res://Engine/BasicNPC.gd"

func interact():
	if get_owner().ready_to_ask_for_keycard:
		DiagHelper.start_talk(self, "GoAway")
	else:
		DiagHelper.start_talk(self, "Welcome")

func get_out_of_building():
	get_tree().get_current_scene().forced_out_entrance()

func assume_positions():
	$Tween.interpolate_property(global.get_player(1), "position", null, Vector2(-780, 280), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property(global.get_player(2), "position", null, Vector2(-765, 280), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
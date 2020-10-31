extends "res://NPC/NPCBasic/NPCBasic.gd"

func interact():
	if global.get_player(1).position.y < position.y: # if behind...
		DiagHelper.start_talk(self, "Behind")
		return
	if get_owner().ready_to_ask_for_keycard:
		DiagHelper.start_talk(self, "GoAway")
	else:
		DiagHelper.start_talk(self, "Welcome")

func get_out_of_building():
	get_tree().get_current_scene().forced_out_entrance()

func assume_positions():
	var orange = get_tree().get_current_scene().get_node("YSort/Orange")
	var green = get_tree().get_current_scene().get_node("YSort/Player")
	orange.controlled_by = orange.EXTERNAL
	green.controlled_by = green.EXTERNAL
	$Tween.interpolate_property(global.get_player(1), "position", null, Vector2(-786, 280), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property(global.get_player(2), "position", null, Vector2(-765, 280), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

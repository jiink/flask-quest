extends StaticBody2D

var story_state
var green
var orange
var ribbit

var green_wake_pos
var green_sleep_pos
var orange_sleep_pos
var ribbit_sleep_pos

var interactable = true

onready var scene_root = get_tree().get_current_scene()

func interact():
	if interactable:
		if story_state == 6:
			DiagHelper.start_talk(self, "Sleep")
			green = global.get_player(1)
			orange = global.get_player(2)
			ribbit = global.get_player(3)
		else:
			DiagHelper.start_talk(self, "CantSleep")
	else:
		pass

func sleep():
	interactable = false
	
	green_wake_pos = green.position
	green_sleep_pos = $GreenSleepPos.position + position
	orange_sleep_pos = $OrangeSleepPos.position + position
	ribbit_sleep_pos = $RibbitSleepPos.position + position
	
	var orange_original_controller = orange.controlled_by
	green.controlled_by = green.EXTERNAL
	orange.controlled_by = orange.EXTERNAL
	ribbit.controlled_by = ribbit.EXTERNAL
	
	$Tween.interpolate_property(orange, "position",
	null, orange_sleep_pos, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	yield(get_tree().create_timer(3), "timeout")
	$Tween.interpolate_property(green, "position",
	null, green_sleep_pos, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	$Tween.interpolate_property(ribbit, "position",
	null, ribbit_sleep_pos, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()

	yield($Tween, "tween_all_completed")
	yield(get_tree().create_timer(3), "timeout")
	scene_root.time_of_day = scene_root.TimesOfDay.MORNING
	scene_root.set_time()
	scene_root.poppy_story_state = scene_root.StoryState.VISIT_PURPLE
	
	yield(get_tree().create_timer(2), "timeout")
	$Tween.interpolate_property(green, "position",
	null, green_wake_pos, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.interpolate_property(ribbit, "position",
	null, green_wake_pos, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.interpolate_property(orange, "position",
	null, green_wake_pos, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	
	orange.clear_history()
	ribbit.clear_history()
	green.controlled_by = green.PERSON
	orange.controlled_by = orange_original_controller
	ribbit.controlled_by = ribbit.BOT
	
	DiagHelper.start_talk(self, "Wake")

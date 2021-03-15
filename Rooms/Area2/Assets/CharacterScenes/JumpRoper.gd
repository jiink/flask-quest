extends "res://NPC/NPCBasic/NPCBasic.gd"

#var interactable = true
onready var green = global.get_player(1)
onready var orange = global.get_player(2)
var green_anim_pos = Vector2(1516, -174.25)
var orange_anim_pos = Vector2(1488, -169)
var green_release_pos = Vector2(1500, -150)
var orange_release_pos = green_release_pos + Vector2(8, 0)

func interact():
	if interactable:
		interactable = false
		var original_orange_controller = orange.controlled_by
		
		var original_green_pos = green.position
		var original_orange_pos = orange.position
		
		green.controlled_by = green.EXTERNAL
		orange.controlled_by = orange.EXTERNAL
		$Tween.interpolate_property(global.get_player(1), "position", \
		 null, green_anim_pos, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN)
		$Tween.interpolate_property(global.get_player(2), "position", \
		 null, orange_anim_pos, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN)
		$Tween.start()
		yield($Tween, "tween_all_completed")
		
		
		$AnimationPlayer.play("JumpLoopPlayer")
		$Timer.start(4)
		
		yield($Timer, "timeout")
		$AnimationPlayer.play("JumpLoop")
		$Tween.interpolate_property(global.get_player(1), "position", \
		 null, original_green_pos, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN)
		$Tween.interpolate_property(global.get_player(2), "position", \
		 null, original_green_pos, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN)
		$Tween.start()
		yield($Tween, "tween_all_completed")
		
		green.clear_history()
		orange.controlled_by = original_orange_controller
		green.controlled_by = green.PERSON
		interactable = true

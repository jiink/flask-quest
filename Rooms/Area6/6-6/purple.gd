extends "res://NPC/NPCWalking/NPCWalking.gd"

onready var scene_root = get_tree().get_current_scene()

onready var green = global.get_player(1)
onready var orange = global.get_player(2)
onready var ribbit = global.get_player(3)

onready var green_anim_start_pos = Vector2(45, -84)
onready var orange_anim_start_pos = Vector2(55, -92)
onready var ribbit_anim_start_pos = Vector2(67, -93)

func interact():
	DiagHelper.start_talk(self, "Welcome")

func lead_players():
	green.controlled_by = green.EXTERNAL
	orange.controlled_by = orange.EXTERNAL
	ribbit.controlled_by = ribbit.EXTERNAL
	
	$Tween.interpolate_property(green, "position",
	null, green_anim_start_pos, 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(orange, "position",
	null, orange_anim_start_pos, 1.2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(ribbit, "position",
	null, ribbit_anim_start_pos, 0.9, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$AnimationPlayer.play("lead_players")
	yield($AnimationPlayer, "animation_finished")
	
#	setup for dinner sequence in 6-1 on the balcony
	scene_root.current_dinner_state = 1
	global.start_scene_switch("res://Rooms/Area6/6-1/6-1.tscn", Vector2(408, -521), "down")
	global.swap_scenes()

func lead_back():
	$AnimationPlayer.play("lead_back")
	yield($AnimationPlayer, "animation_finished")
	DiagHelper.start_talk(self, "Goodbye")
	
func release_players():
	green.controlled_by = green.PERSON
	ribbit.controlled_by = ribbit.BOT
	scene_root.current_dinner_state = 0
	if PlayerStats.player_count == 1:
		orange.controlled_by = orange.BOT
	else:
		orange.controlled_by = orange.PERSON
	$AnimationPlayer.play("leave")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

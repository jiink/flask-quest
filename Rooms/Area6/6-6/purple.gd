extends "res://NPC/NPCWalking/NPCWalking.gd"

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

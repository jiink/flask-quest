extends "res://NPC/NPCWalking/NPCWalking.gd"

onready var green = global.get_player(1)
onready var path_follow = get_tree().get_current_scene().get_node("SashaPath/PathFollow2D")
var in_follow_mode = false
var max_follow_dist = 0.013

func interact():
	if interactable:
		DiagHelper.start_talk(self, "General")

func _ready():
	interactable = true
	$Tween.interpolate_property(path_follow, "unit_offset",
	null, path_follow.unit_offset, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	path_follow.unit_offset = 0

func lead_players():
	if in_follow_mode:
		interactable = false
		var dist_to_player = sqrt(pow(green.position.x - position.x, 2) + \
		pow(green.position.y - position.y, 2))
		var inverse_dist = (1/dist_to_player) * 0.7 ### NEVER GO TO ZERO DISTANCE, PLAYERS!
		print(inverse_dist)
		if inverse_dist < max_follow_dist:
			inverse_dist = 0
		if path_follow.unit_offset + inverse_dist > 1:
			end_follow()
		else:
			$Tween.interpolate_property(path_follow, "unit_offset",
			null, path_follow.unit_offset + inverse_dist,
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			yield($Tween, "tween_all_completed")
			lead_players()
			
func end_follow():
	in_follow_mode = false
	DiagHelper.start_talk(self, "EndFollow")

func return_to_desk():
	interactable = false
	$Tween.interpolate_property(path_follow, "unit_offset",
	null, 0,
	20, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	interactable = true

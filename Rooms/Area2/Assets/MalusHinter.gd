extends "res://NPC/NPCWalking/NPCWalking.gd"

var currently_walking
var left_scene

const SAVE_KEY = "2-1_malus_hinter_"

func save(save_game):
	save_game.data[SAVE_KEY + "left"] = left_scene

func load(save_game):
	left_scene = save_game.data[SAVE_KEY + "left"]
	print(left_scene)
	if left_scene:
		self.queue_free()

func interact():
	if not currently_walking:
		DiagHelper.start_talk(self, "AskToJoin")

func enter_pizza_place():
	currently_walking = true
	$Tween.interpolate_property(self, "position", \
	 null, $Position2D.position + position, 10, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	visible = false
	position = Vector2(600,-440)
	left_scene = true

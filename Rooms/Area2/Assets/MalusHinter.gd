extends "res://NPC/NPCWalking/NPCWalking.gd"

var currently_walking = false
var left_scene = false


const SAVE_KEY = "2-1_malus_hinter_"

func save(save_game):
	save_game.data[SAVE_KEY + "left"] = left_scene

func load(save_game):
	left_scene = save_game.data[SAVE_KEY + "left"]
	print("DID I LEAVE ALREADY? %s" % left_scene)
	if left_scene:
		self.queue_free()
	else:
		visible = true
		position = Vector2(1008, -343)
	yield(get_tree().create_timer(1), "timeout")
	
func interact():
	if (not currently_walking) and interactable:
		DiagHelper.start_talk(self, "AskToJoin")

func start_diag(diagpiece, wait_time = 0.2):
	interactable = false
	yield(get_tree().create_timer(wait_time), "timeout")
	interactable = true
	DiagHelper.start_talk(self, diagpiece)

func enter_pizza_place():
	currently_walking = true
	$Tween.interpolate_property(self, "position", \
	 null, $Position2D.position + position, 10, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	visible = false
	position = Vector2(600,-440)
	left_scene = true

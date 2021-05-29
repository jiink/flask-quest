extends "res://NPC/NPCBasic/NPCBasic.gd"

var train_ready = false


func _ready():
	$JumpArea.connect("body_entered", self, "_on_body_entered")

func interact():
	DiagHelper.start_talk(self, main_dialogue)
	
func activate_train():
	get_tree().get_current_scene().get_node("Train").activate(0, 5, 0, Vector2(2000, 0))
	train_ready = true
	
func cutscene():
	global.start_scene_switch("res://Cutscenes/TrainJump/TrainJump.tscn", Vector2(-64,-64))
	global.swap_scenes()
	
func _on_body_entered(body):
	if body == global.get_player(1) and train_ready:
		DiagHelper.start_talk(self, "Jump")

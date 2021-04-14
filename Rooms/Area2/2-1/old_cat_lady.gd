extends "res://NPC/NPCWalking/NPCWalking.gd"

#In dialogue, might want to add a reference to the fact that this woman is forgetful
#(In order to explain why she forgets that you killed the cat when you change scenes)

onready var animator = $AnimationPlayer
var current_dialogue = "Request"
var player_searching = false

func interact():
	DiagHelper.start_talk(self, current_dialogue)
	animator.stop(false)

func accept():
	animator.play("search")
	current_dialogue = "Remind"
	player_searching = true
	
func refuse():
	animator.play("search")
	current_dialogue = "PostRefuse"
	
func mission_finish():
	current_dialogue = "PostMission"
	player_searching = false

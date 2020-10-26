extends "res://NPC/NPCWalking/NPCWalking.gd"

var walking = false
onready var animator = $CharacterMover
enum State { INTRO, INTRO_CLUB, POST_TALK }
var current_state = State.INTRO
var finished_talk

const SAVE_KEY = "2-6_malus_hinter_"

func save(save_game):
	save_game.data[SAVE_KEY + "talked_to"] = finished_talk

func load(save_game):
	finished_talk = save_game.data[SAVE_KEY + "talked_to"]
	if finished_talk:
		current_state = State.POST_TALK
	else:
		current_state = State.INTRO
		
func interact():
	if not walking:
		match current_state:
			State.INTRO:
				DiagHelper.start_talk(self, "Intro")
			State.INTRO_CLUB:
				DiagHelper.start_talk(self, "IntroClub")
			State.POST_TALK:
				DiagHelper.start_talk(self, "PostTalk")

func enter_club():
	walking = true
	animator.play("enter_club")
	yield(animator, "animation_finished")
	walking = false
	current_state = State.INTRO_CLUB

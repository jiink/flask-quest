extends "res://NPC/NPCWalking/NPCWalking.gd"

var walking = false
#onready var camera = get_tree().get_current_scene().get_node("Camera")
onready var camera = get_node("../../Camera")
onready var animator = $CharacterMover
onready var player = global.get_player(1)
onready var pizza_door = get_tree().get_current_scene().get_node("pizza_door")

enum State { INTRO, INTRO_CLUB, POST_TALK, POST_MANHOLE }
var current_state = State.INTRO
var finished_talk
var entered_scene
var manhole_event_happened

const SAVE_KEY = "2-6_malus_hinter_"

func save(save_game):
	save_game.data[SAVE_KEY + "talked_to"] = finished_talk

func load(save_game):
	finished_talk = save_game.data[SAVE_KEY + "talked_to"]
	entered_scene = save_game.data["2-1_malus_hinter_left"]
	manhole_event_happened = save_game.data["2-1_manhole_event_happened"]
	if finished_talk:
		current_state = State.POST_TALK
		animator.play("recenter_in_club")
		pizza_door.lock(false)
	else:
		current_state = State.INTRO
		animator.play("idle_startpos")
		pizza_door.lock(true)
	if manhole_event_happened:
		current_state = State.POST_MANHOLE
	if not entered_scene:
		queue_free()
	
func interact():
	if not walking:
		match current_state:
			State.INTRO:
				DiagHelper.start_talk(self, "Intro")
			State.INTRO_CLUB:
				DiagHelper.start_talk(self, "IntroClub")
			State.POST_TALK:
				DiagHelper.start_talk(self, "PostTalk")
			State.POST_MANHOLE:
				DiagHelper.start_talk(self, "PostManhole")
				
				
func enter_club():
	walking = true
	animator.play("enter_club")
	yield(animator, "animation_finished")
	walking = false
	current_state = State.INTRO_CLUB
	pizza_door.lock(false)
	
func introduce_ari():
	animator.play("introduce_ari")
	
func introduce_alice():
	animator.play("introduce_alice")
	
func introduce_alex():
	animator.play("introduce_alex")

func move_camera_to_club():
	camera.follow_player = false
	$Tween.interpolate_property(camera, "position", \
	null, Vector2(-76,-476), 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	MusicManager.change_music("res://Rooms/Area2/Assets/amazing_cats.ogg", true, 0)
	
func move_camera_to_player():
	$Tween.interpolate_property(camera, "position", \
	null, player.position, 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	camera.follow_player = true
	
func explain_mission():
	animator.play("recenter_in_club")
	yield(animator, "animation_finished")
	DiagHelper.start_talk(self, "MissionExplanation")

func reveal_crutches():
	set_process(false)
	
	anim_speed_scale = 1
	$AnimatedSprite.speed_scale = 1
	auto_direction = false
	$AnimatedSprite.play("reveal_crutches")
	yield($AnimatedSprite, "animation_finished")
	yield(get_tree().create_timer(0.3), "timeout")
	$AnimatedSprite.play("reveal_crutches")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.animation = "down"
	
func alex_break_leg():
	animator.play("alex_break_leg")

func give_map_credentials():
	ItemManager.give_item("map_login")
	current_state = State.POST_TALK
	finished_talk = true

extends "res://NPC/NPCWalking/NPCWalking.gd"

onready var scene_root = get_tree().get_current_scene()

func _ready():
	
#	The regular contents of the ready function....
	
	add_to_group("tick")
	# see what animation-related variables to set up
	# Assumes NPC has the other idle directions too
	has_dedicated_idle_animations = sprite.frames.has_animation("down_idle") 
	has_dedicated_left_animation = sprite.frames.has_animation("left")

	if up_down_periodic_mirroring:
		sprite.connect("animation_finished", self, "_on_animation_finished")
	
	sprite.playing = true
	
#	...With an additional feature!
#	$RefDoor.queue_free()
#	$RefFloor.queue_free()
	
	
func initiate_dinner():
	$AnimationPlayer.play("start_dinner")
	yield($AnimationPlayer, "animation_finished")
	DiagHelper.start_talk(self, "Initial")
	
func pause(next_diag):
	yield(get_tree().create_timer(2), "timeout")
	DiagHelper.start_talk(self, next_diag)

func end_dinner():
	scene_root.current_dinner_state = 2
	scene_root.current_story_state = scene_root.StoryState.SLEEP_HOTEL
	$AnimationPlayer.play("end_dinner")
	yield($AnimationPlayer, "animation_finished")
	global.start_scene_switch("res://Rooms/Area6/6-6/6-6.tscn", Vector2(-104, 245))
	global.swap_scenes()

extends "res://NPC/NPCBasic/NPCBasic.gd"

onready var scene_root = get_tree().get_current_scene()
onready var sasha = $"../Sasha"
var sasha_follow_mode = false

func interact():
	if sasha_follow_mode:
		DiagHelper.start_talk(self, "FollowRemind")
	else:
		if scene_root.poppy_story_state == scene_root.StoryState.GET_HOTEL_ROOM:
			DiagHelper.start_talk(self, "GetRoom")
		elif scene_root.poppy_story_state == scene_root.StoryState.VEHICLE:
			DiagHelper.start_talk(self, "Sorrow")
		else:
			DiagHelper.start_talk(self, "Else")

func sasha_arrive():
	pass
	
func release_players():
	scene_root.poppy_story_state = scene_root.StoryState.MURK_MONSTER
	sasha.in_follow_mode = true
	sasha_follow_mode = true
	sasha.lead_players()

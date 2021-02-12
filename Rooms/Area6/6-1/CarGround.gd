extends StaticBody2D


onready var scene_root = get_tree().get_current_scene()


func interact():
	if scene_root.current_story_state == scene_root.StoryState.PUSHED_VEHICLE:
#		Battle BATTLE BATTLE
		print("You fought hard and well. Here's your prize: the rest of the game!")
		scene_root.current_story_state = scene_root.StoryState.DINNER
		DiagHelper.start_talk(self, "BattleFinished")
	else:
		DiagHelper.start_talk(self, "PurpleLawn")

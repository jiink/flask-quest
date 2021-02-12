extends StaticBody2D

var interactable = true
onready var animator = $AnimationPlayer
onready var scene_root = get_tree().get_current_scene()

func interact():
	if interactable:
		DiagHelper.start_talk(self)

func push_car():
	interactable = false
	animator.play("fall")
	yield(animator, "animation_finished")
	scene_root.current_story_state = scene_root.StoryState.PUSHED_VEHICLE
	queue_free()

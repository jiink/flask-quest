extends KinematicBody2D

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	if get_tree().get_current_scene().current_story_state == 0:
		yield(get_tree().create_timer(1.5), "timeout")
		DiagHelper.start_talk(self)	
	
func drive_away():
	$AnimationPlayer.play("drive_away")


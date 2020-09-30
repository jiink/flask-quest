extends KinematicBody2D

func _ready():
	if not get_tree().get_current_scene().pre_kidnap_events_occured:
		yield(get_tree().create_timer(1.5), "timeout")
		DiagHelper.start_talk(self)	
	
func drive_away():
	$AnimationPlayer.play("drive_away")


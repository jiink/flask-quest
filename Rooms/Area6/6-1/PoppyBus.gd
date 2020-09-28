extends KinematicBody2D


func _ready():
	yield(get_tree().create_timer(1.5), "timeout")
	DiagHelper.start_talk(self)
	
	
func drive_away():
	$AnimationPlayer.play("drive_away")
	
	
func suicide():
	queue_free()

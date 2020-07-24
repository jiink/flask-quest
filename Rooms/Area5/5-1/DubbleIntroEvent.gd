extends Node2D



func _ready():
	$OverlayAnimator.play("wake_up")
	yield(get_tree().create_timer(3), "timeout")
	DiagHelper.start_talk(self)

func dubble_walk_by():
	

extends Node2D



func _ready():
	$OverlayAnimator.play("wake_up")
	yield(get_tree().create_timer(3), "timeout")
	DiagHelper.start_talk(self)

func dubble_walk_by():
	$CharacterMovement.play("dubble_walk_by")

func door_knock():
	$DoorKnockAudio.playing = true
	
func green_wake():
	print("**************Let the player move around now.***********")

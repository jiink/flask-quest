extends Node2D

var enabled = 0
func interact():
	if enabled == 0:
		$AnimationPlayer.play("turnon")
		enabled = 1
	else:
		$AnimationPlayer.play("turnoff")
		enabled = 0

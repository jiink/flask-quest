extends Node2D

func _ready():
	var x = randf()
	if x < 0.5:
		$AnimationPlayer.play("att_a")
		$Timer.start(7)
	else:
		$AnimationPlayer.play("att_b")
		$Timer.start(5.5)

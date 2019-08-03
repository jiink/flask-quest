extends Node2D

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	$AnimationPlayer.play_backwards("elevator_open_animation")
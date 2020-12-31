extends Node2D

onready var rat_root = $RatRoot
onready var rat_animator = $RatRoot/AnimationPlayer

func _ready():
	rat_animator.play("idle")
	yield(get_tree().create_timer(0.5), "timeout")
	var target_rot = int(rand_range(45, 360))
	$Tween.interpolate_property(rat_root, "rotation_degrees", \
		null, target_rot, 2, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	yield(get_tree().create_timer(0.2), "timeout")
	rat_animator.play("close_in")
	yield(rat_animator, "animation_finished")
	rat_animator.play_backwards("close_in")

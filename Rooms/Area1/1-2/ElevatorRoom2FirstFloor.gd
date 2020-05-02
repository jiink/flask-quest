extends "res://Rooms/Tools/Elevator/ElevatorRoom.gd"

func _on_TriggerField_body_entered(body):
	if body == get_tree().get_nodes_in_group("Player")[0]:
		yield(get_tree().create_timer(0.5), "timeout")
		$FloorArrowIndicator.set_animation(direction)
		yield(get_tree().create_timer(2.1), "timeout")
		DiagHelper.start_talk(self)
		

func _on_AnimationPlayer_animation_finished(anim):
	pass

func done():
	yield(get_tree().create_timer(1.0), "timeout")
	$AnimationPlayer.play("open")
	$FloorArrowIndicator.set_animation("off")

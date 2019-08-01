extends Node2D




func _on_TriggerField_body_entered(body):
	if body == get_tree().get_nodes_in_group("Player")[0]:
		$AnimationPlayer.play("godown")
		$elevator_floor_indicator.set_process(true)
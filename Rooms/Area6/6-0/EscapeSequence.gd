extends Area2D


func _on_EscapeTrigger_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player"):
		body.frozen = true
		$CollisionShape2D.set_deferred("disabled", true)
		$"../Camera".follow_player = false
		
		####Camera tween
		yield(get_tree().create_timer(0.5), "timeout")
		$Tween.interpolate_property($"../Camera", "position",
			null, Vector2(299, -49),
			3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.start()
		####
		
		yield(get_tree().create_timer(3), "timeout")
		$"../BusPath/AnimationPlayer".play("bus_stop")
		
		yield(get_tree().create_timer(6), "timeout")
		DiagHelper.start_talk(self)

func diag_finished():
	$"../BusPath/AnimationPlayer".play("bus_go")

	yield(get_tree().create_timer(4), "timeout")
	global.start_scene_switch("res://Rooms/Area6/6-1/6-1.tscn", Vector2(0,0))
	global.swap_scenes()

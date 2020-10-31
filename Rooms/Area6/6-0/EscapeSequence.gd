extends Area2D

onready var green = global.get_player(1)
onready var orange = global.get_player(2)
onready var camera = get_tree().get_current_scene().get_node("6-0/Camera")
func _on_EscapeTrigger_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player"):
		green.controlled_by = green.EXTERNAL
		orange.controlled_by = orange.EXTERNAL
		body.frozen = true
		$"../Camera".follow_player = false
		$CollisionShape2D.set_deferred("disabled", true)
		yield(get_tree().create_timer(0.5), "timeout")
		$Tween.interpolate_property(green, "position", 
			null, Vector2(350,-15),
			2, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		$Tween.interpolate_property(orange, "position", 
			null, Vector2(340,0),
			2, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		$Tween.interpolate_property($"../Camera", "position",
			null, Vector2(299, -49),
			3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.start()

		####Camera tween
		yield(get_tree().create_timer(0.5), "timeout")
		$Tween.interpolate_property($"../Camera", "position",
			null, Vector2(299, -49),
			2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		####
		
		yield(get_tree().create_timer(3), "timeout")
		$"../BusPath/AnimationPlayer".play("bus_stop")
		
		yield(get_tree().create_timer(6), "timeout")
		DiagHelper.start_talk(self)

func diag_finished():
	$Tween.interpolate_property(green, "position", 
		null, Vector2(350,-40),
		0.1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	$Tween.interpolate_property(orange, "position", 
		null, Vector2(350,-40),
		0.1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	green.visible = false
	orange.visible = false
	$"../BusPath/AnimationPlayer".play("bus_go")

	yield(get_tree().create_timer(6), "timeout")
	global.start_scene_switch("res://Rooms/Area6/6-1/6-1.tscn", Vector2(667,-78))
	global.swap_scenes()

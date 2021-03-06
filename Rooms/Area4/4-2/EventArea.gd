extends Area2D

func _on_EventArea_body_entered(body):
	if body == global.get_player():
		body.frozen = true
		#$"Collisionshape2D".set_deferred("disabled", true)
		MusicManager.change_music("res://Engine/zzzzzz.ogg", true, 0.1)
		$"../Camera".follow_player = false
		
		yield(get_tree().create_timer(0.5), "timeout")
		$Tween.interpolate_property($"../Camera", "position",
			null, Vector2(-351, -236),
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		
		yield(get_tree().create_timer(0.7), "timeout")
		$AnimationPlayer.play("Startled")
		
		yield(get_tree().create_timer(0.5), "timeout")
		DiagHelper.start_talk(self)
		
func close_in():
	$AnimationPlayer.play("CloseIn")
	yield(get_tree().create_timer(0.8), "timeout")
	global.start_battle(["MalusTopGuardA"])
	yield(get_tree().create_timer(4), "timeout")

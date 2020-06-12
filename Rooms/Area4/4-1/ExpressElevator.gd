extends Sprite




func _on_OnArea_body_entered(body):
	print("something's in the elevator")
	if body == global.get_player():
		$AnimationPlayer.play("startup")
		print("a player is in the elevator")
		$"..".level_music = preload("res://Rooms/Common/elevator.ogg")
		MusicManager.update_music("level")
		
func _on_AnimationPlayer_animation_finished(anim_name):
	print("animation finished!")
	if anim_name == "startup":
		$AnimationPlayer.play("motion")
		$OnArea/CollisionShape2D.disabled = true
		yield(get_tree().create_timer(1), "timeout")
		DiagHelper.start_talk(self)

func elevator_stop():
	$AnimationPlayer.play("stop")
	yield(get_tree().create_timer(4.5), "timeout")
	$elevator_stop/ScenePortal/CollisionShape2D.set_deferred("disabled", false)
	print("sceneport col SHOULD be ENABLED")

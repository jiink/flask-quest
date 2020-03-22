extends Sprite




func _on_OnArea_body_entered(body):
	print("something's in the elevator")
	if body == global.get_player():
		$AnimationPlayer.play("startup")
		print("a player is in the elevator")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "startup":
		$AnimationPlayer.play("motion")

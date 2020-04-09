extends Sprite

func shake_camera():
	get_parent().get_node("Camera").shake()

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

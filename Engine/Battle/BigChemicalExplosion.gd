extends Sprite

func shake_camera():
	if global.in_battle:
		get_tree().get_current_scene().get_node("BattleScene/Camera").shake()
	else:
		get_tree().get_current_scene().get_node("Camera").shake()

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

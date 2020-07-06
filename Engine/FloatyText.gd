extends Node2D

func set_text(s):
	$Label.text = s

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

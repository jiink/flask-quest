extends Node2D

func _on_AnimationPlayer_animation_finished(anim_name):
	global.start_battle("SecurityGuard")

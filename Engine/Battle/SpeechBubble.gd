extends Label

func _ready():
	$AnimationPlayer.set_speed_scale(randf() * 0.5 + 0.75)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

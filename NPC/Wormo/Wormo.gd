extends "res://NPC/Base/FoeFollow.gd"

func _process(delta):
	if chasing:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("default")
	else:
		if $AnimationPlayer.is_playing():
			$Sprite.frame = 0
			$AnimationPlayer.stop()

extends "res://Engine/Battle/Dodger/Projectiles/GenericProjectile.gd"

var y_velocity = 0

var dropping = false

func _ready():
	scale += Vector2(randf() * 0.1, randf() * 0.1)
	if $AnimationPlayer and $Spin:
		$AnimationPlayer.playback_speed += randf() * 0.15
		$AnimationPlayer.seek(randf() * $AnimationPlayer.current_animation_length)
		$Spin.playback_speed += randf() * 0.15
		$Spin.seek(randf() * $AnimationPlayer.current_animation_length)
	
func drop():
	dropping = true
	if $Spin:
		$Spin.stop()
	
func _process(delta):
	if dropping:
		y_velocity += 0.1
		position.y += y_velocity
		if position.y > 300:
			queue_free()
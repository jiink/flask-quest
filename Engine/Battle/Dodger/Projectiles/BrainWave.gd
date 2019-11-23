extends "res://Engine/Battle/Dodger/Projectiles/GenericProjectile.gd"

func _process(delta):

	scale.x += 0.05
	scale.y += 0.052
	position.x += 1
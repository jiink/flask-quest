extends "res://Engine/Battle/Dodger/Projectiles/GenericProjectile.gd"

func _process(delta):

	scale.x += 3 * delta
	scale.y += 3.12 * delta
	position.x += 60 * delta

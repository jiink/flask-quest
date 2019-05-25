extends "res://Engine/Battle/Dodger/Projectiles/GenericProjectile.gd"

export(float) var speed_change = 1

func _process(delta):
	vec *= speed_change
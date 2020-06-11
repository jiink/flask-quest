extends "res://Engine/Battle/Dodger/Projectiles/GenericProjectile.gd"

export(float) var speed = 100
export(float) var speed_change = 1

func _process(delta):
	var vec = Vector2(speed, 0).rotated(rotation)
	position += vec * delta
	speed *= speed_change


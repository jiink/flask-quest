extends "res://Engine/Battle/Dodger/Projectiles/GenericProjectile.gd"

export(float) var speed = 100
export(float) var speed_change = 1
var vec 

func _process(delta):
	vec = Vector2(speed, 0).rotated(rotation)
	position += vec * delta
	speed *= speed_change


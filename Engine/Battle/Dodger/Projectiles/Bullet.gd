extends "res://Engine/Battle/Dodger/Projectiles/GenericProjectile.gd"

export(float) var speed = 100
export(float) var speed_change = 1

var vec

func _ready():
	vec = Vector2(speed, 0).rotated(rotation)

func _process(delta):
	position += vec * delta
	vec *= speed_change
extends "res://Engine/Battle/Dodger/Projectiles/GenericProjectile.gd"

export(Vector2) var initial_v = Vector2(0, 0)

var vec

func _ready():
	vec = initial_v
	$Particles2D.emitting = true
	
func _process(delta):
	position += vec * delta
	vec.y += 120*delta

func _tick():
	if position.y <= 108:
		set_type(ORANGE)
	else:
		set_type(GREEN)
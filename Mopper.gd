extends "res://Engine/Battle/Dodger/Projectiles/GenericProjectile.gd"

var travel_vec = Vector2(0.0, 0.0)
var ready = false
var speed = 0.5

func _ready():
	$StartTimer.start(0.6 + randf() * 0.7)

func _process(delta):
	if ready:
		position += travel_vec * speed

func _on_StartTimer_timeout():
	travel_vec = Vector2(randf() - 0.5, randf() - 0.5).normalized()
	ready = true

extends Node2D

var b_count = 5
var b = load("res://Engine/Battle/Dodger/Projectiles/Bullet/Bullet.tscn")
var spd = randf() * .5 - .2

func _on_FireTimer_timeout():
	if b_count > 0:
		var bi = b.instance()
		add_child(bi)
		bi.set_position(Vector2(-16, randi() % 100 + 50))
		bi.vec *= 1 + spd
		b_count -= 1

extends Node2D

var b_count = 15
var b = load("res://Engine/Battle/Dodger/Projectiles/Bullet/Bullet.tscn")

func _on_FireTimer_timeout():
	var bi = b.instance()
	add_child(bi)
	bi.set_position(Vector2(-16, randi() % 100 + 50))
	b_count -= 1

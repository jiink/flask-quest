extends Sprite

func explode():
	var explo = preload("res://Effects/Explosions/SmallPopExplosion.tscn").instance()
	get_parent().add_child(explo)
	explo.position = Vector2(position.x, position.y + 8)
	queue_free()

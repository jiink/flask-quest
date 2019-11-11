extends "res://Engine/Battle/Dodger/Projectiles/Bullet.gd"

var target_transf = Vector2(128, 128)

func _process(delta):
	
	target_transf = global.get_dodger(1).get_global_transform()[2] if global.get_dodger(1) else target_transf
	
	look_at(target_transf)
	vec = Vector2(speed, 0).rotated(rotation)

func destroy():
	var boom_instance = preload("res://Engine/Battle/Dodger/Projectiles/BoomExplosion.tscn").instance()
	get_parent().add_child(boom_instance)
	boom_instance.position = position
	queue_free()
	emit_signal("successful_hit")
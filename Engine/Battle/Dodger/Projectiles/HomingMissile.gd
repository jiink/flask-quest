extends "res://Engine/Battle/Dodger/Projectiles/Bullet.gd"

func _process(delta):
	
	var target_transf = global.get_green_dodger().get_global_transform()
	
	look_at(target_transf[2])
	vec = Vector2(speed, 0).rotated(rotation)

func destroy():
	var boom_instance = preload("res://Engine/Battle/Dodger/Projectiles/BoomExplosion.tscn").instance()
	get_parent().add_child(boom_instance)
	boom_instance.position = position
	queue_free()
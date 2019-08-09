extends "res://Engine/Battle/Dodger/Projectiles/GenericProjectile.gd"

export(float) var spin_speed = 0.02
export(float) var pull_speed = 0.003
export(float) var size = 1.0

func _ready():
#	$Sprite.scale = Vector2(size, size)
	$Sprite.scale = Vector2(0.0, 0.0)
	$CollisionShape2D.scale = Vector2(size, size)
	$Tween.interpolate_property($Sprite, "scale",
			Vector2(0.0, 0.0), Vector2(size, size),
			0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	
func _process(delta):
	# counter the rotation so sprite and collision stay upright
	$Sprite.rotation = -rotation
	$CollisionShape2D.rotation = -rotation
	
	rotation += spin_speed
	if scale.x > 0:
		scale -= Vector2(pull_speed, pull_speed)
	else: 
		queue_free()
extends "res://Engine/Battle/Dodger/Projectiles/Bullet.gd"

var bounce_height = 64
var original_y

func _ready():
	speed += randf()*0.2
	$SpriteAnimation.playback_speed += randf()*0.2
	$SpriteAnimation.seek(randf()*$SpriteAnimation.current_animation_length)
	original_y = position.y


func _process(delta):
#	position.y = original_y + abs(sin(d
	print(position.y)
	pass
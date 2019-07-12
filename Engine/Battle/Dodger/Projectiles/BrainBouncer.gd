extends "res://Engine/Battle/Dodger/Projectiles/GenericProjectile.gd"

var bounce_height = 64
var original_y

func _ready():
	original_y = position.y


func _process(delta):
#	position.y = original_y + abs(sin(d
	print(position.y)
	pass
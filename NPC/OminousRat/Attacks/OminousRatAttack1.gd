extends Node2D

func _ready():
	$Rat.position.y += floor(randf() * 72.0 - 36.0)
	$Rat.set_type(floor(randf() * 2))


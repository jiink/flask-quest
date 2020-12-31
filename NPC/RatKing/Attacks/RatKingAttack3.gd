extends Node2D

onready var rat_root = $RatRoot
var rand_y_pos

func _ready():
	rand_y_pos = rand_range(-33, 58)
	rat_root.position.y = rand_y_pos

func tween_y_pos():
	rand_y_pos = rand_range(-33, 58)
	$Tween.interpolate_property(rat_root, "position", \
		null, Vector2(0, rand_y_pos), 0.5, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	$Tween.start()

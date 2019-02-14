extends Node2D

var max_hp = 100
var hp = max_hp

var damage = 15

func _ready():
	add_to_group("foes")
extends Node2D

onready var rat_root = $RatRoot


func _ready():
	var rand_rot = rand_range(0, 180)
	rat_root.rotation_degrees = rand_rot

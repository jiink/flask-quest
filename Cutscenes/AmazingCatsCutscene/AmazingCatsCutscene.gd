extends Node2D

onready var sprite = $amazing_cats_cutscene

func next_frame():
	sprite.frame += 1
	
func set_frame(frame):
	sprite.frame = 1

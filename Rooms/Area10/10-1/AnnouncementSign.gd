extends Node2D

onready var label = $Label
onready var tween = $Tween
onready var text_start_pos = $TextStartPos.position
var letter_length_multiplier = 8

func announce(announcement, speed):
	label.text = announcement
	label.rect_position = text_start_pos
	
	var char_count = 0
	for character in announcement:
		char_count += 1
	
	tween.interpolate_property(label, "rect_position",
	null, label.rect_position - Vector2(char_count * letter_length_multiplier, 0),
	speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

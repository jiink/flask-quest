extends Node2D

export(float) var transition_time = 0.0

onready var control_rect = $ColorRect
onready var green = global.get_player(1)
onready var tween = $Tween
onready var check_zone = Rect2(Vector2(control_rect.rect_position),
	Vector2(control_rect.rect_size))

var tweened_in = false
var tweened_out = true

var transparent_modulate = Color(1.0, 1.0, 1.0, 0.0)
var opaque_modulate = Color(1.0, 1.0, 1.0, 1.0)

#func _draw():
#	draw_rect(check_zone, Color(1.0, 1.0, 1.0))

func _ready():
	control_rect.visible = true

func _tick():
	if check_zone.has_point(green.position - position):
#		yield(tween, "tween_all_completed")
		if tweened_in == false:
			tweened_out = false
			tweened_in = true
			tween.stop_all()
			tween.interpolate_property(control_rect, "modulate", \
			 opaque_modulate, transparent_modulate, transition_time, 
			 Tween.TRANS_QUAD, Tween.EASE_IN)
			tween.start()
			yield(tween, "tween_all_completed")
			control_rect.visible = false
			
		else:
			pass
			
	else:
#		yield(tween, "tween_all_completed")
		if tweened_out == false:
			tweened_in = false
			tweened_out = true
			tween.stop_all()
			control_rect.visible = true
			tween.interpolate_property(control_rect, "modulate", \
			 transparent_modulate, opaque_modulate, transition_time, 
			 Tween.TRANS_QUAD, Tween.EASE_IN)
			tween.start()
			yield(tween, "tween_all_completed")
		else:
			pass

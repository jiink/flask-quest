extends ColorRect

signal done_fading_out

func _ready():
	visible = true
	fade_in()

func fade_out():
	$Tween.interpolate_property(self, "color",
			Color('000e111c'), Color('ff0e111c'),
			0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func fade_in():
	$Tween.interpolate_property(self, "color",
			Color('ff0e111c'), Color('000e111c'),
			0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()



func _on_Tween_tween_completed(object, key):
	emit_signal("done_fading_out")
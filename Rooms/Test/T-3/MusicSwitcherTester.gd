extends Node2D

var toggled_track = 1
export(int) var transition_time = 1.0

func _ready():
	$Track1.play()
	$Track2.play()
	$ColorRect.color = Color.magenta

func interact():
	print("doing it")
	match toggled_track:
		1:
			toggled_track = 2
			$Tween.interpolate_method($Track1, "set_volume_linear", 1.0, 0.0, transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.interpolate_method($Track2, "set_volume_linear", 0.0, 1.0, transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$ColorRect.color = Color.yellow
		2:
			toggled_track = 1
			$Tween.interpolate_method($Track1, "set_volume_linear", 0.0, 1.0, transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.interpolate_method($Track2, "set_volume_linear", 1.0, 0.0, transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$ColorRect.color = Color.magenta

	$Tween.start()

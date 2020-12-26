extends Node2D

var might_skip = false
var allow_really_skipping = false # will pressing a button ACTUALLY skip the custscene?

func end_cutscene():
	global.start_scene_switch("res://Rooms/Area1/1-1/1-1.tscn", Vector2(224,101))
	global.swap_scenes()


func _on_AnimationPlayer_animation_finished(anim_name):
	end_cutscene()


func _ready():
	$SkipNoInputsTimer.connect("timeout", self, "_on_skipnoinputstimer_timeout")
	$SkipTimer.connect("timeout", self, "_on_skiptimer_timeout")


func _input(event):
	if (event.is_action_pressed("confirm") or event.is_action_pressed("cancel") 
	or event.is_action_pressed("action") or event.is_action_pressed("special")):
		if allow_really_skipping:
			end_cutscene()

		if not might_skip:
			might_skip = true
			$SkipLabel.visible = true
			$SkipNoInputsTimer.start()


# the user may now press more buttons to skip, or not press anything to not skip
func _on_skipnoinputstimer_timeout():
	$SkipTimer.start()
	allow_really_skipping = true


func _on_skiptimer_timeout():
	might_skip = false
	allow_really_skipping = false
	$SkipLabel.visible = false
	

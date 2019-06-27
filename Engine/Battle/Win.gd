extends Node2D

onready var fade = $"../Fade"

func start():
	$TimeUntilFade.start(3.0)
	$AnimationPlayer.play("roll_in")

func _on_TimeUntilFade_timeout():
	fade.connect("done_fading_out", self, "_on_done_fading_out")
	fade.fade_out()

func _on_done_fading_out():
	var battle = $".."
	battle.exit_battle()
extends Node2D

onready var fade = $"../Fade"
var dollar_label_value = 0

func _ready():
	set_process(false)

func _process(delta):
	$BottomBar/Label.text = "+ $%s" % int(dollar_label_value)
	
	
func start():
	$AnimationPlayer.play("roll_in")
	
	PlayerStats.dollars += int($"..".total_dollar_reward)
	
	$TimeUntilFade.start(1.65)

	
	
	
func _on_TimeUntilFade_timeout():
	fade.connect("done_fading_out", self, "_on_done_fading_out")
	fade.fade_out()

func _on_done_fading_out():
	var battle = $".."
	battle.exit_battle()

func _on_AnimationPlayer_animation_finished(anim_name):
	$Tween.interpolate_property(self, "dollar_label_value",
			0, $"..".total_dollar_reward,
			0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	
	set_process(true)
	

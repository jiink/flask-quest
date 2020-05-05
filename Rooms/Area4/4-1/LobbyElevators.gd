extends Node2D

func interact():
	start_alarm()
	yield(get_tree().create_timer(0.5), "timeout")
	DiagHelper.start_talk(self)

func become_ready_for_keycard_asking():
	get_owner().ready_to_ask_for_keycard = true

func start_alarm():
	$Alarms.visible = true
	$Alarms/AudioStreamPlayer.playing = true
	$Alarms/AnimationPlayer.play("on")
	yield(get_tree().create_timer(25), "timeout")
	stop_alarm()

func stop_alarm():
	$Alarms.visible = false
	$Alarms/AudioStreamPlayer.playing = false
	$Alarms/AnimationPlayer.seek(0)
	$Alarms/AnimationPlayer.stop()
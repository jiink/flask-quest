extends Node2D

# Requires a timer child (with one shot ON)
# and an interaction
# and a sound to play

export(AudioStream) var audio
export(float) var audio_pitch = 1
export(float) var interval = 0.5
export(int) var repeats = 40


onready var audio_player = $Audio
onready var timer = $Timer

func _ready():
	audio_player.set_stream(audio)
	audio_player.pitch_scale = audio_pitch
	timer.wait_time = interval

func interact():
	for n in repeats:
		audio_player.play()
		timer.start()
		yield(timer, "timeout")

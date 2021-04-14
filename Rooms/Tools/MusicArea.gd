extends Node2D

export(AudioStream) var new_music
export(float) var fade_time = 0.2
export(bool) var start_from_beginning
export(float) var new_reverb = 0 # set to 0 to disable reverb
export(float) var default_reverb = 0
export(float) var new_delay_time = 0 # set to 0 to not use delay
export(float) var default_delay_time = 0

var sfx_bus = AudioServer.get_bus_index("SFX")
var default_music
onready var scene_root = get_tree().get_current_scene()
var reverb_effect
var delay_effect

func _ready():
	default_music = scene_root.level_music
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	reverb_effect = AudioServer.get_bus_effect(sfx_bus, 1)
	delay_effect = AudioServer.get_bus_effect(sfx_bus, 0)

func _on_body_entered(body):
	if body == global.get_player(1):
		MusicManager.change_music(new_music, start_from_beginning, fade_time)
		
#		if new_reverb == 0:
#			reverb_effect.wet = 0
#			print("exiting reverb disabled")
#		else:
#			reverb_effect.wet = 0.28
#			reverb_effect.room_size = new_reverb
#			print("entering reverb ENABLED")
#
#		if new_delay_time == 0:
#			delay_effect.set_tap1_active(false)
#			delay_effect.set_tap2_active(false)
#		else:
#			delay_effect.set_tap1_active(true)
#			delay_effect.set_tap2_active(true)
#			delay_effect.set_tap1_delay_ms(new_delay_time*0.5)
#			delay_effect.set_tap2_delay_ms(new_delay_time)
			
			
func _on_body_exited(body):
	if body == global.get_player(1):
		MusicManager.change_music(default_music, start_from_beginning, fade_time)
		
#		if default_reverb == 0:
#			reverb_effect.wet = 0
#			print("exiting reverb disabled")
#		else:
#			reverb_effect.wet = 0.28
#			reverb_effect.room_size = default_reverb
#			print("entering reverb ENABLED")
#
#		if default_delay_time == 0:
#			delay_effect.set_tap1_active(false)
#			delay_effect.set_tap2_active(false)
#		else:
#			delay_effect.set_tap1_active(true)
#			delay_effect.set_tap2_active(true)
#			delay_effect.set_tap1_delay_ms(default_delay_time*0.5)
#			delay_effect.set_tap2_delay_ms(default_delay_time)

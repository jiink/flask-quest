extends Node2D

var active = false

func _ready():
	set_tv_active(active)
	

func set_tv_active(on):
	if on:
		$tv_side_light.set_process(true)
		$tv_side_light.enabled = true
		$AudioStreamPlayer.play()
	else:
		$tv_side_light.set_process(false)
		$tv_side_light.enabled = false
		
	active = on
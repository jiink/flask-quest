extends Node2D

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "alert_global")
	
	visible = true
	$AnimationPlayer.play("open")
	$"/root/GameSaver".load(1)
	
func fade_out():
	visible = true
	$AnimationPlayer.play("close")
	
func alert_global(anim):
	if anim == "close":
		get_node("/root/global").swap_scenes()
extends Node2D

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "alert_global")
	
	visible = true
	$AnimationPlayer.play("open")
	$"/root/GameSaver".load()
	
func fade_out():
	visible = true
	$AnimationPlayer.play("close")
	global.get_player().set_frozen(true, true)
	
func alert_global(anim):
	if anim == "close":
		get_node("/root/global").swap_scenes()
		
		
	elif anim == "open":
		visible = false

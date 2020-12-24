extends Node2D

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "alert_global")
	
	visible = true
	$AnimationPlayer.play("open")
	$"/root/GameSaver".load()
	
func fade_out():
	visible = true
	$AnimationPlayer.play("close")
	var p = global.get_player()
	if p.has_method("set_frozen"):
		global.get_player().set_frozen(true, true)
	
func alert_global(anim):
	if anim == "close":
		get_node("/root/global").swap_scenes()
		
		
	elif anim == "open":
		visible = false

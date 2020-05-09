extends Node2D

onready var diag = get_tree().get_current_scene().get_node("HUD/Diag") # gotta check if its visible for later

func _ready():
	global.get_player().frozen = true
	$AnimationPlayer.play("turn_on")
	

func _input(event):
	if event.is_action_pressed("cancel") and (not diag.visible):
		global.get_player().frozen = false
		$AnimationPlayer.play("turn_off")
		get_tree().set_input_as_handled()
		


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "turn_on":
		if "map_login" in ItemManager.inventory:
			$AnimationPlayer.play("log_in")
		else:
			DiagHelper.start_talk(get_tree().get_current_scene().get_node("YSort/MapMachine"))
#			DiagHelper.start_talk(get_node(".."))
	
	elif anim_name == "turn_off":
		queue_free()

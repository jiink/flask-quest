extends Node2D

func _ready():
	global.get_player().frozen = true
	$AnimationPlayer.play("turn_on")

func _process(delta):
	if Input.is_action_just_released("cancel"):
		global.get_player().frozen = false
		$AnimationPlayer.play("turn_off")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "turn_on":
		if "map_login" in ItemManager.inventory:
			$AnimationPlayer.play("log_in")
		else:
			DiagHelper.start_talk(get_tree().get_current_scene().get_node("YSort/MapMachine"))
#			DiagHelper.start_talk(get_node(".."))
	
	elif anim_name == "turn_off":
		queue_free()

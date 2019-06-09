extends Node2D



func _on_AnimationPlayer_animation_finished(anim_name):
	var battle_scene = load("res://Engine/Battle/BattleScene.tscn").instance()
	
	
	get_tree().get_current_scene().get_node("Camera").current = false
	#get_tree().paused = true
	
	$"/root/global".custompause(get_tree().get_current_scene(), true)
	
	for child in get_tree().get_current_scene().get_children():
		if not child.get("visible") == null:
			child.visible = false
		
	
	get_tree().get_current_scene().add_child(battle_scene)
	
	get_tree().get_current_scene().get_node("BattleScene/Camera").current = true
	
	for i in get_tree().get_nodes_in_group("WorldFoes"):
		if not i.is_processing():
			i.queue_free()
	
	$"/root/MusicManager".update_music("battle")
	
	queue_free()
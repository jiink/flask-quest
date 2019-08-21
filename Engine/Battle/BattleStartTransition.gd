extends Node2D

export(int) var shader_frequency = 0
export(float) var shader_depth = 0.0

func _ready():
	$"/root/MusicManager/AnimationPlayer".play("fade_out")
	
func _process(delta):
	$Shader.get_material().set_shader_param("frequency", shader_frequency)
	$Shader.get_material().set_shader_param("depth", shader_depth)
	global.get_player().frozen = true
	

func _on_AnimationPlayer_animation_finished(anim_name):
	
	for i in get_tree().get_nodes_in_group("WorldFoes"):
		if not i.is_processing():
			i.queue_free()
		else:
			i.speed /= 1.5
			i.follow_distance /= 1.5

	var battle_scene = preload("res://Engine/Battle/BattleScene.tscn").instance()
	
	get_tree().get_current_scene().get_node("Camera").current = false
	#get_tree().paused = true
	
	$"/root/global".custompause(get_tree().get_current_scene(), true)
	
	for child in get_tree().get_current_scene().get_children():
		if not child.get("visible") == null:
			child.visible = false
		
	
	get_tree().get_current_scene().add_child(battle_scene)
	
	get_tree().get_current_scene().get_node("BattleScene/Camera").current = true
	
#	$"/root/MusicManager".update_music("none")
	
	queue_free()
extends Node2D

export(int) var shader_frequency = 0
export(float) var shader_depth = 0.0

onready var player = global.get_player(1)

func _ready():
#	$"/root/MusicManager/AnimationPlayer".play("fade_out")
#	for i in get_tree().get_nodes_in_group("WorldFoes"):
#		print("AAAAAAAAAAAAAAAAAAA" + str(i))

	var foe = load("res://NPC/" + global.initial_enemies[0] + "/" + global.initial_enemies[0] + "Foe.tscn")
	print("res://NPC/" + global.initial_enemies[0] + "/" + global.initial_enemies[0] + "Foe.tscn")
	var foe_instance = foe.instance()
	if foe_instance.custom_music != null:
		MusicManager.change_music(foe_instance.custom_music, true, 1.0)
	else:
		print("There is NO custom music to play!!!!")
		MusicManager.change_music(get_tree().get_current_scene().get("battle_music"), false, 1.0)
	print("AAAAAAAAAAAAAAAAAAAAAAAAAA" + foe_instance.name)
	foe_instance.queue_free()
	
	# close inventory
	global.get_hud().get_node("InventoryMenu").set_visible(false)
	
	player.set_frozen(true, true)
	
func _process(delta):
	$Shader.get_material().set_shader_param("frequency", shader_frequency)
	$Shader.get_material().set_shader_param("depth", shader_depth)
	player.set_frozen(true, false)
	

func _on_AnimationPlayer_animation_finished(anim_name):
	
	for i in get_tree().get_nodes_in_group("WorldFoes"):
		print("BBBBBBBBBBBBBBBB" + i.name)
		if not i.is_processing():
			i.queue_free()
		else:
			# i.speed /= 1.5
			# i.follow_distance /= 1.5
			pass

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

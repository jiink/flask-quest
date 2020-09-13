extends "res://Rooms/Tools/ScenePortal.gd"


func on_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player"):
		print(str(body.name) + " entered sceneportal")
		
		var prisoner_frog = get_node("../YSort/PrisonerFrog")
		prisoner_frog.current_mission_state = prisoner_frog.MissionStates.SUPERTUNNEL_EXITED
		
		if new_scene != "":
			#get_tree().change_scene(new_scene)
			global.start_scene_switch(new_scene, player_new_position, starting_direction)
		else:
			print("error: new_scene empty")
			

extends Node2D

export (Vector2) var player_new_position = null

export(AudioStream) var new_song
export(bool) var start_from_beginning
export(float) var fade_time

func _ready():
	connect("body_entered", self, "on_body_entered")
	
func on_body_entered(body):
#	print(body.name)

	# in 1P, only P1 can go through but in >1P anyone can
	if (body == global.get_player(1)) or \
	(PlayerStats.player_count > 1 and body in get_tree().get_nodes_in_group("Player")):
		print("%s entered positionportal" % body.name)
		
		if has_node("Position2D"):
			print("%s -> %s" % [body.position, $Position2D.get_global_transform()[2]])
			for b in get_tree().get_nodes_in_group("Player"):
				b.position = $Position2D.get_global_transform()[2]
			get_tree().get_current_scene().get_node("HUD/PositionTransition").go()
		elif player_new_position != null:
			for b in get_tree().get_nodes_in_group("Player"):
				b.position = player_new_position
			get_tree().get_current_scene().get_node("HUD/PositionTransition").go()
		else:
			print("error: teleportal doesn't have destination")
			return
		
		# clear green's position history
		for i in range(global.get_player(1).position_history.size()):
			global.get_player(1).position_history[i] = body.position
		# make orange teleport there too
		if global.get_player(2):
			global.get_player(2).position = body.position
			global.get_player(2).get_node("AnimationPlayer").play("appear")
		
		# Change music if wanted
		if new_song != null:
			MusicManager.change_music(new_song, start_from_beginning, fade_time)
extends Node2D

export (Vector2) var player_new_position = null

func _ready():
	connect("body_entered", self, "on_body_entered")
	
func on_body_entered(body):
#	print(body.name)
	if body == get_tree().get_nodes_in_group("Player")[0]:
		print("%s entered positionportal" % body.name)
		
		if has_node("Position2D"):
			print("%s -> %s" % [body.position, $Position2D.get_global_transform()[2]])
			body.position = $Position2D.get_global_transform()[2]
			get_owner().get_node("HUD/PositionTransition").go()
		elif player_new_position != null:
			body.position = player_new_position.position
			get_owner().get_node("HUD/PositionTransition").go()
		else:
			print("error: teleportal doesn't have destination")

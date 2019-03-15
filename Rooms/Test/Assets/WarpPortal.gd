extends Node2D

export (Vector2) var player_new_position = null

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")
	$AnimationPlayer.play("normal")
	
func on_body_entered(body):
	print(str(body.name) + " entered teleportal")
	
	
	if has_node("Position2D"):
		print("%s -> %s" % [body.position, $Position2D.get_global_transform()[2]])
		body.position = $Position2D.get_global_transform()[2]
	elif player_new_position != null:
		body.position = player_new_position.position
	else:
		print("error: teleportal doesn't have destination")
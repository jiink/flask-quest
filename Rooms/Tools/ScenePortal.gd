extends Node2D

enum StartingDirection { NONE, UP, RIGHTUP, RIGHT, RIGHTDOWN, DOWN, LEFTDOWN, LEFT, LEFTUP }

export (String, FILE, "*.tscn") var new_scene = ""
export (Vector2) var player_new_position = null
export(StartingDirection) var starting_direction = StartingDirection.NONE

func _ready():
	connect("body_entered", self, "on_body_entered")
	
func on_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player"):
		print(str(body.name) + " entered sceneportal")
		
		if new_scene != "":
			#get_tree().change_scene(new_scene)
			global.start_scene_switch(new_scene, player_new_position, starting_direction)
		else:
			print("error: new_scene empty")

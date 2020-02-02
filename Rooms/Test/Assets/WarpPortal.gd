extends Node2D

export (String, FILE, "*.tscn") var new_scene = ""
export (Vector2) var player_new_position = null

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")
	$AnimationPlayer.play("normal")
	
func on_body_entered(body):
	print(str(body.name) + " entered portal")
	
	if new_scene != "":
		#get_tree().change_scene(new_scene)
		get_node("/root/global").start_scene_switch(new_scene, player_new_position)
	else:
		print("error: new_scene empty")

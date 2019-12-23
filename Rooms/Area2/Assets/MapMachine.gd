extends Sprite

func interact():
	print("open the map!") # open the map
	# here we will open the map:
	var map_scene = load("res://Rooms/Area2/Assets/LanettaMap.tscn")
	map_scene = map_scene.instance()
	get_owner().get_node("HUD").add_child(map_scene)
	

func _ready():
	$OnArea.connect("body_entered", self, "on_body_entered")
	$OnArea.connect("body_exited", self, "on_body_exited")
	
	frame = 0
	
func on_body_entered(body):
	if body == global.get_player():
		$AnimationPlayer.play("turn_on")

func on_body_exited(body):
	if body == global.get_player():
		$AnimationPlayer.play("turn_off")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "turn_on":
		$AnimationPlayer.play("running")
	
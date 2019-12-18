extends Sprite

func interact():
	print("open the map!") # open the map
	# here we will open the map:
	var map_scene = load("res://Rooms/Area2/Assets/LanettaMap.tscn")
	map_scene = map_scene.instance()
	get_owner().get_node("HUD").add_child(map_scene)
	
	###############
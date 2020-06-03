extends Node2D

# spawns the crows of douglas followers on the left and right of the "'red' carpet"

var num_tube_men = 150

func _ready():
	var tube_man_scene = preload("res://NPC/TubeManDouglist/TubeManDouglistCrowdMember.tscn")
	# spawn tube men on right
	spawn_crowd_members(tube_man_scene, Vector2(-84, 12), Vector2(16, 1286), 200)
	# spawn tube men on left
	spawn_crowd_members(tube_man_scene, Vector2(-84 - 154, 12), Vector2(16 - 154, 1286), 200)

	var cloaky_scene = preload("res://NPC/CloakyDouglist/CloakyDouglistCrowdMember.tscn")
	# spawn tube men on right
	spawn_crowd_members(cloaky_scene, Vector2(-84, 12), Vector2(16, 1286), 200)
	# spawn tube men on left
	spawn_crowd_members(cloaky_scene, Vector2(-84 - 154, 12), Vector2(16 - 154, 1286), 200)
	

func spawn_crowd_members(member_scene, spawn_zone_top_left, spawn_zone_bottom_right, num_to_spawn):
	for i in range(num_to_spawn):
		var member_instance = member_scene.instance()
		member_instance.set_position(Vector2( \
			int(rand_range(spawn_zone_top_left.x, spawn_zone_bottom_right.x)), \
			int(rand_range(spawn_zone_top_left.y, spawn_zone_bottom_right.y)) \
		))
		add_child(member_instance)

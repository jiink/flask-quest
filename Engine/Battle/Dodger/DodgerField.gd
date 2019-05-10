extends Node2D

var rot =   0.0
var rot_v = 0.0

var rot_speed = 30
var max_rot_speed = 3.0
var rot_friction = 42

var attacks_spawned = false
var battle

func _ready():

	if get_node("..").name == "BattleScene":
		battle = get_node("..")
	else:
		print("Warning: Parent not BattleScene")
		battle = null
		
func _process(delta):
	if visible:
		move_players(delta)
		
		if not attacks_spawned and battle != null:
			
			for f in battle.get_foes().size():
				var foe = battle.get_foes()[f]
				var foe_name = foe.get_name()
				foe_name = foe_name.replace("@", "")
				foe_name = foe_name.replace("Foe", "")
				for i in range(9):
					foe_name = foe_name.replace(str(i), "")
				print(foe_name)
				var att_dir = get_attacks_in_dir("res://NPC/%s/Attacks/" % foe_name)
				var look = "res://NPC/%s/Attacks/" % foe_name
				
				print("att dir size: %s" % att_dir.size())
				var attack_num = randi() % att_dir.size() + 1
				print("loop %s: attack nuber:: %s" % [f, attack_num])
				#print(get_attacks_in_dir("res://NPC/%s/Attacks/" % foe.name.replace("Foe", "")))
				var attack_scene_path = "res://NPC/%s/Attacks/Attack%s.tscn" % [foe_name, attack_num]
				
				var attack_scene = load(attack_scene_path)
				attack_scene = attack_scene.instance()
				attack_scene.position = Vector2(-192, -108)
				$Attacks.add_child(attack_scene)
				
				##TODO: FIX THIS DOWN HERE !!
				get_node("Attacks/Attack%s/Timer" % attack_num).connect("timeout", self, "att_timeout")
				
	#			print("should have loaded attack scene")
	#			for child in get_children():
	#				print("Child: %s" % child.name)
			attacks_spawned = true
		
		$Dodgers/GreenSprite.visible = not $"/root/PlayerStats".green_hp <= 0
		$Dodgers/OrangeSprite.visible = not $"/root/PlayerStats".orange_hp <= 0
		
		if $"/root/PlayerStats".green_hp <= 0 and $"/root/PlayerStats".orange_hp <= 0:
			stop()
			
func move_players(delta):
	rot_v =  clamp(rot_v, -max_rot_speed, max_rot_speed)
	if Input.is_action_pressed("left"):
		rot_v -= rot_speed * delta
	elif Input.is_action_pressed("right"):
		rot_v += rot_speed * delta
	else:
		rot_v *= rot_friction * delta
	
	rot += rot_v
	$Dodgers.set_rotation_degrees(rot)

func stop():
	attacks_spawned = false
	battle.end_dodge_game()
	rot = 0.0
	rot_v = 0.0

func att_timeout():
	for i in $Attacks.get_children():
		i.queue_free()
	print("time's up!")
	stop()

func run():
	pass

func get_attacks_in_dir(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".tscn"):
			files.append(file)

#	dir.list_dir_end()

	return files
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
			var foe = battle.get_foes()[0]
			var attack_num = 1
			var attack_scene_path = "res://NPC/%s/Attacks/Attack%s.tscn" % [foe.name.replace("Foe", ""), attack_num]
			print(attack_scene_path)
			
			var attack_scene = load(attack_scene_path)
			attack_scene = attack_scene.instance()
			attack_scene.position = Vector2(-192, -108)
			add_child(attack_scene)
			print("should have loaded attack scene")
			attacks_spawned = true
			for child in get_children():
				print("Child: %s" % child.name)
	

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
	
func run():
	pass
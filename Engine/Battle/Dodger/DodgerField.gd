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
			$Attacks.add_child(attack_scene)
			get_node("Attacks/Attack%s/Timer" % attack_num).connect("timeout", self, "att_timeout")
			
			print("should have loaded attack scene")
			attacks_spawned = true
			for child in get_children():
				print("Child: %s" % child.name)
		
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
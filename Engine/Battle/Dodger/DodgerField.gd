extends Node2D

var rot =   0.0
var rot_v = 0.0

var rot_speed = 0.55
var max_rot_speed = 4.0
var rot_friction = .85

var attacks_spawned = false
var battle

var shielded = false
var shield_time = 0.2
var shield_delay = 0.2

var active_battle_timer

onready var pstats = $"/root/PlayerStats"
onready var green = $Dodgers/GreenSprite
onready var orange = $Dodgers/OrangeSprite

signal spawn_attack

func _ready():

	if get_node("..").name == "BattleScene":
		battle = get_node("..")
	else:
		print("Warning: Parent not BattleScene")
		battle = null
	
	$ShieldTimer.connect("timeout", self, "shield_timer_timeout")
	$AnimationPlayer.play_backwards("appear")
	connect("spawn_attack", self, "spawn_attack")
	
func _process(delta):
	if battle.state == battle.DODGE_GAME:
		move_players(delta)
		
		if $ShieldDelay.is_stopped():
			if Input.is_action_just_pressed("confirm"):
				shielded = true
				green.get_node("InstaShield").visible = true
				orange.get_node("InstaShield").visible = true
				$ShieldTimer.start(shield_time)
		
		if not attacks_spawned and battle != null:
			
#			var timers = []
			attacks_spawned = true
			for foe_index in battle.get_foes().size():
				emit_signal("spawn_attack", foe_index)
				# don't spawn all of the attacks at once, have time between them?
				var wait_time = randf()*2+.5
				yield(get_tree().create_timer(wait_time), "timeout")
				# timer starting in the spawn_attack func
#					timers.append(attack_scene.get_node("Timer"))
				
#			var longest_timer_time = 0.1
#			var timer_index = 0
#			if timers.size() > 0:
#				for i in range($Attacks.get_child_count()):
#					if timers[i].wait_time > longest_timer_time:
#						longest_timer_time = timers[i].wait_time
#						timer_index = i
#				active_battle_timer = timers[timer_index]
#
#				active_battle_timer.connect("timeout", self, "att_timeout")
#				attacks_spawned = true
#			else:
#				att_timeout()
		
		$Dodgers/GreenSprite.visible = not pstats.green_hp <= 0
		$Dodgers/OrangeSprite.visible = not pstats.orange_hp <= 0
		
		if pstats.green_hp <= 0 or pstats.orange_hp <= 0:
			stop()
			get_tree().change_scene_to(load("res://Rooms/Deadlands/Deadlands.tscn"))
		
	if active_battle_timer != null:
		$DodgeCircle/TimeBar.value = int(100 * (active_battle_timer.time_left / active_battle_timer.wait_time))


func spawn_attack(foe_index):
	print("running spawn_attack()...")
	
	var foe = battle.get_foes()[foe_index]
	
	# clean up the foe name. @BobFoe11 -> Bob
	var foe_name = foe.get_name()
	foe_name = foe_name.replace("@", "")
	foe_name = foe_name.replace("Foe", "")
	for i in range(9): # take out any numbers
		foe_name = foe_name.replace(str(i), "")
	print(foe_name)
	
	# get list of files in the attack directory
	var att_dir = get_attacks_in_dir("res://NPC/%s/Attacks/" % foe_name)
	var look = "res://NPC/%s/Attacks/" % foe_name
	
	print("att dir size: %s" % att_dir.size())
	if att_dir.size() <= 0: # if the attack directory has no attacks in it get out
		return

	var attack_num
	if foe.attack_order != "": # foe can have a sequence of attack indicies to go through
		attack_num = foe.attack_order[foe.attack_order_index]
		print("%s is choosing attack #%s, index %s from his list" % [foe_name, attack_num, foe.attack_order_index])
		foe.attack_order_index += 1
		# loop the attack sequence
		if foe.attack_order_index >= foe.attack_order.length():
			foe.attack_order_index = 0
	else:
		print("%s is choosing random attack" % foe_name)
		attack_num = randi() % att_dir.size() + 1
		
	print("loop %s: attack nuber:: %s" % [foe_index, attack_num])

	var attack_scene_path = "res://NPC/%s/Attacks/%sAttack%s.tscn" % [foe_name, foe_name, attack_num]
	
	var attack_scene = load(attack_scene_path)
	attack_scene = attack_scene.instance()
	attack_scene.position = Vector2(-192, -108)
	$Attacks.add_child(attack_scene)
	
	attacks_spawned = true
	
	# start the timer when the last attack spawns
	if foe_index == battle.get_foes().size()-1:
		active_battle_timer = attack_scene.get_node("Timer")
		active_battle_timer.connect("timeout", self, "att_timeout")


func move_players(delta):
	rot_v =  clamp(rot_v, -max_rot_speed, max_rot_speed)
	if Input.is_action_pressed("left"):
		rot_v -= rot_speed * Input.get_action_strength("left")
	elif Input.is_action_pressed("right"):
		rot_v += rot_speed * Input.get_action_strength("right")
	else:
		rot_v *= rot_friction 
	
	rot += rot_v*delta*60
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
	active_battle_timer = null
	stop()

func run():
	pass

func shield_timer_timeout():
	shielded = false
	green.get_node("InstaShield").visible = false
	orange.get_node("InstaShield").visible = false
	$ShieldDelay.start(shield_delay)

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

func hazard_has_hit(who, damage):
	damage = int(round(damage))
	match who:
		1:
			PlayerStats.green_hp -= damage
			PlayerStats.green_hp = clamp(PlayerStats.green_hp, 0, 9999)
			$DodgeCircle/GreenHPBar.update_bar()
			$DamageSound.play()
		2:
			PlayerStats.orange_hp -= damage
			PlayerStats.orange_hp = clamp(PlayerStats.orange_hp, 0, 9999)
			$DodgeCircle/OrangeHPBar.update_bar()
			$DamageSound.play()
		_:
			print("warning: hazard_has_hit %s" % who)

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

export(Array, PackedScene) var attack_scenes



onready var level_music = preload("res://Engine/Battle/AttackTesting.ogg")

func _ready():
	$ShieldTimer.connect("timeout", self, "shield_timer_timeout")
	
	for attack in attack_scenes:
		var AttackInstance = attack.instance()
		$Attacks.add_child(AttackInstance)
		AttackInstance.position = Vector2(-192, -108)
		yield(get_tree().create_timer(randf()*2+.5), "timeout")
		
	
func _process(delta):
	move_players(delta)
	
	if $ShieldDelay.is_stopped():
		if Input.is_action_just_pressed("confirm"):
			shielded = true
			green.get_node("InstaShield").visible = true
			orange.get_node("InstaShield").visible = true
			$ShieldTimer.start(shield_time)
		
	active_battle_timer = $Attacks.get_child(0).get_node("Timer")
		
	$Dodgers/GreenSprite.visible = not pstats.green_hp <= 0
	$Dodgers/OrangeSprite.visible = not pstats.orange_hp <= 0
		
	if pstats.green_hp <= 0 or pstats.orange_hp <= 0:
		stop()
		
	if active_battle_timer != null:
		$DodgeCircle/TimeBar.value = int(100 * (active_battle_timer.time_left / active_battle_timer.wait_time))
			
func move_players(delta):
	rot_v =  clamp(rot_v, -max_rot_speed, max_rot_speed)
	if Input.is_action_pressed("left"):
		rot_v -= rot_speed * Input.get_action_strength("left")
	elif Input.is_action_pressed("right"):
		rot_v += rot_speed * Input.get_action_strength("right")
	else:
		rot_v *= rot_friction 
#	rot_v = (Input.get_action_strength("right") - Input.get_action_strength("left")) * rot_speed
#	if Input.get_action_strength("right") == 0 and Input.get_action_strength("left") == 0:
	
	rot += rot_v*delta*60

	$Dodgers.set_rotation_degrees(rot)

func stop():
	print("battle has stopped")
	rot = 0.0
	rot_v = 0.0

func att_timeout():
	for i in $Attacks.get_children():
		i.queue_free()
	print("time's up!")
	stop()

func shield_timer_timeout():
	shielded = false
	green.get_node("InstaShield").visible = false
	orange.get_node("InstaShield").visible = false
	$ShieldDelay.start(shield_delay)

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

extends Node2D

var rot =   0.0
var rot_v = 0.0

var rot_speed = 0.55
var max_rot_speed = 4.0
var rot_friction = .85

var attacks_spawned = false
var battle

var active_battle_timer

onready var pstats = $"/root/PlayerStats"

signal spawn_attack

export(Array, PackedScene) var attack_scenes

onready var level_music = preload("res://Engine/Battle/AttackTesting.ogg")

func _ready():

	for attack in attack_scenes:
		var AttackInstance = attack.instance()
		$Attacks.add_child(AttackInstance)
		AttackInstance.position = Vector2(-192, -108)
		yield(get_tree().create_timer(randf()*2+.5), "timeout")
	
	
func _process(delta):
	
	$GreenPawn.move(delta)
	$OrangePawn.move(delta)
		
	$GreenPawn.visible = not pstats.green_hp <= 0
	$OrangePawn.visible = not pstats.orange_hp <= 0
	
	if pstats.green_hp <= 0 or pstats.orange_hp <= 0:
		stop()
		get_tree().change_scene_to(load("res://Rooms/Deadlands/Deadlands.tscn"))
	
	if active_battle_timer != null:
		$DodgeCircle/TimeBar.value = int(100 * (active_battle_timer.time_left / active_battle_timer.wait_time))



func stop():
	attacks_spawned = false
	battle.end_dodge_game()
	rot = 0.0
	rot_v = 0.0


func att_timeout():
	for i in $Attacks.get_children():
		i.queue_free()
#    print("time's up!")
	active_battle_timer = null
	stop()


func run():
	pass


func hazard_has_hit(who, damage):
	print("%s HAS BEEEEEN HIT!" % who)
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


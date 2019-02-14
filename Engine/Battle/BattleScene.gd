extends Node

signal hit_foe

var state = "player turn"
var selected_foe = 0

onready var global = get_node("/root/global")
var foe = load("res://Engine/Battle/BaseFoe.tscn")

func _ready():
	
	#
	print(global.initial_enemies)
	for i in range(global.initial_enemies.size()):
		var foe = load("res://NPC/" + global.initial_enemies[i] + "/" + global.initial_enemies[i] + "Foe.tscn")
		var foe_instance = foe.instance()
		foe_instance.set_name(global.initial_enemies[i])
		foe_instance.position.x = 80 * i + 64
		foe_instance.position.y = 128
		$Foes.add_child(foe_instance)
		
	global.current_enemies = global.initial_enemies
	
	# battle bg
	$BattleBG.texture = global.battle_bg
	
func _process(delta):
	if state == "player turn":
		get_move_choice()
	elif state == "player choose enemy":
		$SelectedFoeArrow.visible = true
		get_enemy_choice()

func get_move_choice():
	if Input.is_action_just_pressed("a"):
		state = "player choose enemy"
	elif Input.is_action_just_pressed("b"):
		exit_battle()
		
func get_enemy_choice():
	
	if Input.is_action_just_pressed("right"):
			selected_foe = (selected_foe+1) % get_foes().size()
			
	elif Input.is_action_just_pressed("left"):
			selected_foe = (selected_foe-1) % get_foes().size()
	
	set_arrow_pos()
	
	if Input.is_action_just_pressed("a"):
		attack()
		#state = "attacking"

func set_arrow_pos():
	if selected_foe != null:
		$SelectedFoeArrow.visible = true
		$SelectedFoeArrow.position.x = get_foes()[selected_foe].position.x
		$SelectedFoeArrow.position.y = 64 
	else:
		$SelectedFoeArrow.visible = false
		
func get_foes():
	return get_tree().get_nodes_in_group("foes")

func attack():
	print("attaaaack " + get_foes()[selected_foe].name)
	get_foes()[selected_foe].call("get_hurt", 20)
	#emit_signal("hit_foe", get_tree().get_nodes_in_group("foes")[i])
	
	#selected_foe = null
	$SelectedFoeArrow.visible = false
	state = "player turn"
	
func foe_died():
	print("something died, " + str(get_foes().size()) + " foes left")
	if get_foes().size()-1 != 0:
		selected_foe = selected_foe % get_foes().size()
	else:
		exit_battle()

func exit_battle():
	get_tree().change_scene(global.prev_scene)
	
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
		foe_instance.position.x = 64 * i + 64
		foe_instance.position.y = 128
		$Foes.add_child(foe_instance)
		
	global.current_enemies = global.initial_enemies
	
func _process(delta):
	if state == "player turn":
		get_move_choice()
	elif state == "player choose enemy":
		$SelectedFoeArrow.visible = true
		get_enemy_choice()

func get_move_choice():
	if Input.is_action_just_pressed("a"):
		state = "player choose enemy"

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
	$SelectedFoeArrow.position.x = get_foes()[selected_foe].position.x
	$SelectedFoeArrow.position.y = 64 
	
func get_foes():
	return get_tree().get_nodes_in_group("foes")

func attack():
	print("attaaaack " + get_foes()[selected_foe].name)
	#emit_signal("hit_foe", get_tree().get_nodes_in_group("foes")[i])
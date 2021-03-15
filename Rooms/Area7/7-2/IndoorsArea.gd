extends Area2D

export(AudioStream) var outside_music = preload("res://Rooms/Area7/Assets/neracla.ogg")
export(AudioStream) var inside_music = preload("res://Rooms/Area7/Assets/neracla_inside.ogg")

export(NodePath) var indoor_tiles_path = "../Tilemaps/7-2/PPInside"
export(NodePath) var pod_tiles_path = "../Tilemaps/7-2/Polypods"
export(NodePath) var darkness_path = "../Tilemaps/7-2/PPOutside"
export(NodePath) var above_player_path = "../Tilemaps/7-2/AbovePlayerLit"


onready var indoor_tiles
onready var pod_tiles
onready var darkness
onready var above_player

onready var green = global.get_player(1)
onready var orange = global.get_player(2)
onready var ribbit = global.get_player(3)

export var transition_speed = 0.2

var green_inside
var orange_inside
var ribbit_inside

var transparent_player_modulate = Color(1,1,1,0.4)
var opaque_color = Color(1,1,1,1)

var target_modulate = Color(1,1,1,0)
var opposite_target_modulate



func _ready():
	indoor_tiles = get_node(indoor_tiles_path)
	pod_tiles = get_node(pod_tiles_path)
	darkness = get_node(darkness_path)
	above_player = get_node(above_player_path)

	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	for outsider in get_tree().get_nodes_in_group("outsider"):
		outsider.visible = true
	for insider in get_tree().get_nodes_in_group("insider"):
		insider.visible = false
	indoor_tiles.modulate = Color(1,1,1,0)

func _on_body_entered(body):
	if body == green:
		green_inside = true
		print("Green inside!")
		set_indoors(true)
	if body == orange:
		orange_inside = true
		if green_inside:
			orange.modulate = opaque_color
#		print("orange inside!")
#		set_indoors(true)
	if body == ribbit:
		ribbit_inside = true
		if green_inside:
			ribbit.modulate = opaque_color
#		print("ribbit inside!")
#		set_indoors(true)
		
func _on_body_exited(body):
	if body == green:
		green_inside = false
		print("Green left!")
#		check_occupancy()
		set_indoors(false)
	if body == orange:
		orange_inside = false
		if not green_inside:
			orange.modulate = opaque_color
#		print("Orange left!")
#		check_occupancy()
	if body == ribbit:
		ribbit_inside = false
		if not green_inside:
			ribbit.modulate = opaque_color
		
#		print("Ribbit left!")
#		check_occupancy()
		
		
#func check_occupancy():
#	if green_inside == false and orange_inside == false and ribbit_inside == false:
#		print("They're all outside! YAY!")
#		set_indoors(false)
#
#	else:
#		print(green_inside)
#		print(orange_inside)
#		print(ribbit_inside)

func set_indoors(mode):
#	if indoor_tiles.modulate == target_modulate:
		if mode:
			target_modulate = Color(1,1,1,1)
			opposite_target_modulate = Color(1,1,1,0)
			MusicManager.change_music(inside_music, false, 1)
		else:
			target_modulate = Color(1,1,1,0)
			opposite_target_modulate = Color(1,1,1,1)
			MusicManager.change_music(outside_music, false, 1)
			
		orange.modulate = transparent_player_modulate
		ribbit.modulate = transparent_player_modulate
			
		for outsider in get_tree().get_nodes_in_group("outsider"):
			outsider.visible = !mode
		for insider in get_tree().get_nodes_in_group("insider"):
			insider.visible = mode
			
#		indoor_tiles.visible = mode
		darkness.visible = mode
		above_player.visible = !mode
#		pod_tiles.visible = !mode
			
		$Tween.interpolate_property(indoor_tiles, "modulate", null, target_modulate,
		transition_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#		$Tween.interpolate_property(darkness, "modulate", null, target_modulate,
#		transition_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.interpolate_property(pod_tiles, "modulate", null, opposite_target_modulate,
		transition_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		

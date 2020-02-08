extends Node

var player_count = 2 # for "1 player" or "2 player"

var orange = preload("res://Player/Orange.tscn")

var party_members = ["orange"]

var green_max_hp = 100
var green_hp = 100

var orange_max_hp = 100
var orange_hp = 100

var dollars = 0

func _ready():
	global.connect("scene_changed", self, "on_scene_change")
	

func on_scene_change():
	if global.get_player():
		if "orange" in party_members:
			global.get_player().get_parent().call_deferred("add_child", orange.instance())

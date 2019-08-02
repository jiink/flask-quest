extends Node

var orange = preload("res://Player/Orange.tscn")

var party_members = ["orange"]

var green_max_hp = 100
var green_hp = 100

var orange_max_hp = 100
var orange_hp = 100

var dollars = 0


func _ready():
	if "orange" in party_members:
		global.get_player().get_node("../").call_deferred("add_child", orange.instance())
extends Node2D

signal talk(obj)

func _ready():
	connect("talk", get_owner().get_node("HUD/Diag"), "start_talk")
	
func interact():
	emit_signal("talk", self)
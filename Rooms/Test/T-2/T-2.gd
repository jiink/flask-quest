extends "res://Rooms/TemplateRoom.gd"

# lets use this room to test battling any kind of foe
export(Array, String) var foes_to_battle;

func _ready():
	yield(get_tree().create_timer(0.3), "timeout")
	global.start_battle(foes_to_battle)

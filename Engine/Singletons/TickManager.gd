extends Node

var tick_rate = 0.1 # how often a tick happens in seconds
onready var timer = $TickTimer

func _ready():
	timer.connect("timeout", self, "on_ticktimer_timeout")
	timer.start(tick_rate)

func on_ticktimer_timeout():
	get_tree().call_group("tick", "_tick")

func set_tick(who, choice):
	if (choice == true) and (not who.is_in_group("tick")):
		who.add_to_group("tick")
	elif (choice == false) and (who.is_in_group("tick")):
		who.remove_from_group("tick")

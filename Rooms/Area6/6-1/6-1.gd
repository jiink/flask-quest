extends "res://Rooms/TemplateRoom.gd"

const SAVE_KEY = "6-1_"

var pre_kidnap_events_occured = false

func save(save_game):
	save_game.data[SAVE_KEY + "pre_kidnap_events_occured"] = pre_kidnap_events_occured

func load(save_game):
	pre_kidnap_events_occured = save_game.data[SAVE_KEY + "pre_kidnap_events_occured"]
	setup()
	
func setup():
	if pre_kidnap_events_occured:
		var bus = get_node("YSort/Bus")
		var kidnap_event = get_node("KidnapEvent")
		if (bus != null) and (kidnap_event != null):
			bus.queue_free()
			kidnap_event.queue_free()
	

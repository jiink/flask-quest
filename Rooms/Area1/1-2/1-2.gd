extends "res://Rooms/TemplateRoom.gd"

var tv_event_seen = false

var SAVE_KEY = "1-2_"

func save(save_game):
	save_game.data[SAVE_KEY + "tv_event_seen"] = tv_event_seen
	
func load(save_game):
	tv_event_seen = save_game.data[SAVE_KEY + "tv_event_seen"]
	


func _on_TVTriggerZone_body_entered(body):
	if body == global.get_player() and not tv_event_seen:
		start_tv_event()

func start_tv_event():
	print("time for the tv event")
	$TV.set_tv_active(true)
	yield(get_tree().create_timer(0.6), "timeout")
	DiagHelper.start_talk($TV)
	global.get_player(1).direction = 6
	global.get_player(2).direction = 6
	tv_event_seen = true

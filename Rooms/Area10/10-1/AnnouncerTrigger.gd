extends Area2D

export(bool) var play_once = true
export(AudioStream) var announcement
export(String) var announcement_text = "THE CAFETERIA IS OPEN FROM 1 PM UST to 5 AM UST"
export(float) var text_speed = 5

onready var announcer = get_tree().get_current_scene().get_node("AnnouncerAudioPlayer")
var enabled = true

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body == global.get_player(1) and enabled:
		announcer.set_stream(announcement)
		announcer.play()
		for announcement_sign in get_tree().get_nodes_in_group("announcement_sign"):
			announcement_sign.announce(announcement_text, text_speed)
		
func _on_body_exited(body):
	if body == global.get_player(1):
		if play_once == true:
			enabled = false

extends Node2D

var end_travel_distance = 1240 # how far to go before stopping 
var startpos = 0
var speed = 16 # pix/sec

func _ready():
	$TalkZone.connect("body_entered", self, "_on_body_entered")
	$AnimatedSprite.playing = true
	startpos = position.y	

func stop():
	set_process(false) # stop moving


func _on_body_entered(body):
	if body == global.get_player(1):
		DiagHelper.start_talk(self)
		stop()

func _process(delta):
	position.y -= speed * delta
	var dist_travelled = abs(position.y - startpos)
	if dist_travelled >= end_travel_distance:
		stop() 



extends Node2D

enum { GREEN, ORANGE }
enum { LEFT, RIGHT }

export(int) var speed = -45 # use negative for going up/down
export(int, "GREEN", "ORANGE") var type = GREEN
export(int, "LEFT", "RIGHT") var direction = RIGHT

var spotlight_scene = preload("res://NPC/Douglas/AttackSpotlight.tscn")

func _ready():
	$Timer.set_wait_time(0.1)
	$Timer.start()
	$Timer.connect("timeout", self, "_timeout")

func _timeout():
	var spotlight = spotlight_scene.instance()
	spotlight.type = type
	spotlight.direction = direction
	add_child(spotlight)

	$Timer.set_wait_time(3 + randf() * 2)
	$Timer.start()

func _process(delta):
	for s in get_children():
		if s == $Timer: continue
		s.position.y += speed * delta
		if(s.position.y > 500) or (s.position.y < -500):
			s.queue_free()

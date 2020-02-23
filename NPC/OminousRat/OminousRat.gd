extends "res://NPC/BaseFoe/FoeFollow.gd"

var travel_vec = Vector2(0.0, 0.0)
var waiting = false
var t = 1

func _ready():
	$DirectionChangeTimer.connect("timeout", self, "on_directiontimer_timeout")
	$WaitTimer.connect("timeout", self, "on_waittimer_timeout")
	on_directiontimer_timeout()


func _process(delta):
	if not chasing and not waiting:
		move_and_slide(travel_vec * speed)
		if travel_vec.x < 0:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
			
	if chasing or not waiting:
		t += 8*delta
		if t < $Sprite.hframes:
			$Sprite.frame = t
		else:
			$Sprite.frame = 1
			t = 1

func on_directiontimer_timeout():
	travel_vec = Vector2(randf() - 0.5, randf() - 0.5).normalized()
	$WaitTimer.start(1.0 + randf() * 2.0)
	waiting = true
	$Sprite.frame = 0
	print("SLEEP")
	
func on_waittimer_timeout():
	waiting = false
	$DirectionChangeTimer.start(1.0 + randf() * 2.0)
	print("WAKE ME UP INSIDE")

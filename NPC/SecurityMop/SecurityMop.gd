extends "res://Engine/FoeFollow.gd"

var travel_vec = Vector2(0.0, 0.0)

func _ready():
	$DirectionChangeTimer.connect("timeout", self, "on_directiontimer_timeout")
	on_directiontimer_timeout()

func _process(delta):
	if not chasing:
		move_and_slide(travel_vec * speed)

func on_directiontimer_timeout():
	travel_vec = Vector2(randf() - 0.5, randf() - 0.5).normalized()
	$DirectionChangeTimer.start(1.0 + randf() * 2.0)
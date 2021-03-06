extends KinematicBody2D

var travel_vec = Vector2(0.0, 0.0)
var waiting = false
var t = 1
var first_anim_frame = 0

export(int) var speed = 24
export(float) var direction_time_multiplier = 1
export(float) var direction_time_adder = 1
export(float) var wait_time_multiplier = 1
export(float) var wait_time_adder = 1
export(bool) var first_frame_is_idle = false

func _ready():
	$DirectionChangeTimer.connect("timeout", self, "on_directiontimer_timeout")
	$WaitTimer.connect("timeout", self, "on_waittimer_timeout")
	on_directiontimer_timeout()
	if first_frame_is_idle:
		first_anim_frame = 1


func _process(delta):
	if not waiting:
		move_and_slide(travel_vec * speed)
		if travel_vec.x < 0:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
			
	if not waiting:
		t += 8*delta
		if t < $Sprite.hframes:
			$Sprite.frame = t
		else:
			$Sprite.frame = first_anim_frame
			t = 0

func on_directiontimer_timeout():
	travel_vec = Vector2(randf() - 0.5, randf() - 0.5).normalized()
	$WaitTimer.start(wait_time_adder + randf() * wait_time_multiplier)
	waiting = true
	$Sprite.frame = 0
	
func on_waittimer_timeout():
	waiting = false
	$DirectionChangeTimer.start(direction_time_adder + randf() * direction_time_multiplier)

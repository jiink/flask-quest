extends "res://NPC/BaseFoe/FoeTouchEncounter.gd"

export(int) var follow_distance = 100
export(int) var speed = 81

var target_distance
var chasing = false
onready var target = global.get_player()
var angle = 0.0
var focus_position = position # what to swarm around
var goto_position = position # where to go. is near focus_position
var travel_vec = Vector2(0.0, 0.0)

func _ready():
	$DirectionChangeTimer.connect("timeout", self, "on_directiontimer_timeout")
	on_directiontimer_timeout()
		
		
func _tick():
	if target:
		target_distance = get_global_transform().origin.distance_to(target.get_global_transform().origin)
		if target_distance < follow_distance:
			chasing = true
			angle = target.get_global_transform().origin.angle_to_point(get_global_transform().origin)
			$Sprite.flip_h = abs(angle) >= PI*0.5
			focus_position = target.position
		else:
			chasing = false
			
			
func _process(delta):
	if chasing:
#		move_and_slide(Vector2(speed, 0).rotated(angle))
		pass
	move_and_slide(travel_vec) #* speed)
	

func on_directiontimer_timeout():
	# pick a new place to head towards
	var swarm_radius = 48
	goto_position.x = focus_position.x + randf() * swarm_radius
	goto_position.y = focus_position.y + randf() * swarm_radius
	var go_angle = goto_position.angle_to_point(get_global_transform().origin)
	travel_vec = Vector2(speed * randf() + speed * 0.5, 0).rotated(go_angle)
	$DirectionChangeTimer.start(0.5 + randf() * 0.4)
	

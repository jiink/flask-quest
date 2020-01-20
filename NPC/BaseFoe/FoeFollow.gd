extends "res://NPC/BaseFoe/FoeTouchEncounter.gd"

export(int) var follow_distance = 100
export(int) var speed = 24

var target_distance
var chasing = false
onready var target = global.get_player()
var angle = 0.0

func _ready():
	pass
		
func _tick():
	if target:
		target_distance = get_global_transform().origin.distance_to(target.get_global_transform().origin)
		if target_distance < follow_distance:
			chasing = true
			angle = target.get_global_transform().origin.angle_to_point(get_global_transform().origin)
			$Sprite.flip_h = abs(angle) >= PI*0.5
		else:
			chasing = false

func _process(delta):
	if chasing:
		move_and_slide(Vector2(speed, 0).rotated(angle))


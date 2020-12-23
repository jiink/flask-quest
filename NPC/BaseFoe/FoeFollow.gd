extends "res://NPC/BaseFoe/FoeTouchEncounter.gd"

export(int) var follow_distance = 100
export(int) var speed = 24

var target_distance
var chasing = false
onready var target = global.get_player()
var angle = 0.0
var rush = false setget set_rush

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

func set_rush(should_rush):
	rush = should_rush
	if should_rush:
		speed *= 1.5
		follow_distance *= 2.0
		
		# make them not stack on top of eachother
#			# no longer exist on 1st collision layer
#			collision_layer = 4#0b100
		collision_mask = 0 # original is 32768 (bit 15)
	else:
		speed /= 1.5
		follow_distance /= 2.0
		collision_mask = 32768 # (bit 15)

func trigger(): 
	set_process(false)
	TickManager.set_tick(self, false)
	global.start_battle([base_name])

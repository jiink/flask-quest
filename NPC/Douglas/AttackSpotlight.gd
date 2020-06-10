extends Node2D

enum { GREEN, ORANGE }
enum { LEFT, RIGHT }

var type = GREEN
var direction = RIGHT
var initial_delay
var light_scene = preload("res://NPC/Douglas/AttackSpotlightLight.tscn")

func _ready():
	if direction == LEFT:
		rotation_degrees = 180

	match type:
		GREEN:
			$ColorRect.color = global.GREEN_COLOR
		ORANGE:
			$ColorRect.color = global.ORANGE_COLOR

	initial_delay = randf() * 2.0
	yield(get_tree().create_timer(initial_delay), "timeout")
	
	var light = light_scene.instance()
	light.type = type + 1 # that one's enum starts with "normal" which this can't have
	light.direction = direction
	light.position.x = 17
	add_child(light)
	
	

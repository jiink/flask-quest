extends KinematicBody2D

enum Direction { UP, RIGHT, DOWN, LEFT }

export(Direction) var facing_direction = Direction.DOWN setget set_facing_direction
export(bool) var auto_direction = true
export(bool) var interactable = true
export(bool) var up_down_periodic_mirroring = true # every other animation cycle for going up/down, mirror it for "more" frames?
export(float) var anim_speed_scale = 0.5
export(float) var idle_anim_speed_scale = 1
var has_dedicated_idle_animations = false
var has_dedicated_left_animation = false

onready var last_position = position
var delta_pos = Vector2(0, 0)
var moving = false
var last_moving = true # was the npc moving in the last tick?
var moving_threshold = 0.1

var animation_strings = {
	"up" : "up_idle",
	"right" : "right_idle",
	"down" : "down_idle",
	"left" : "left_idle",
}
var animation_strings_walking = animation_strings.keys()
var animation_strings_idle = animation_strings.values()

onready var sprite = $AnimatedSprite

func _ready():
	add_to_group("tick")
	# see what animation-related variables to set up
	# Assumes NPC has the other idle directions too
	has_dedicated_idle_animations = sprite.frames.has_animation("down_idle") 
	has_dedicated_left_animation = sprite.frames.has_animation("left")

	if up_down_periodic_mirroring:
		sprite.connect("animation_finished", self, "_on_animation_finished")
	
	sprite.playing = true

func interact():
	if interactable:
		DiagHelper.start_talk(self)

func _tick():
	delta_pos = position - last_position

	var delta_pos_length = delta_pos.length()

	moving = delta_pos.length() > moving_threshold
	if has_dedicated_idle_animations:
		if not moving:
			sprite.set_animation(animation_strings_idle[facing_direction])
			sprite.speed_scale = 1 * idle_anim_speed_scale
			sprite.playing = true
	else:
		if not moving:
			sprite.playing = moving
#			sprite.set_animation(animation_strings_walking[Direction.DOWN])

	if moving:
		sprite.speed_scale = delta_pos.length() * anim_speed_scale
		
	if (moving) and (not last_moving):
		sprite.set_animation(animation_strings_walking[facing_direction])

	if moving and auto_direction:

		var calculated_dir

		if abs(delta_pos.y) > abs(delta_pos.x):
			if delta_pos.y > 0:
				calculated_dir = Direction.DOWN
			elif delta_pos.y < 0:
				calculated_dir = Direction.UP
				
		elif abs(delta_pos.x) > abs(delta_pos.y):
			if delta_pos.x > 0:
				calculated_dir = Direction.RIGHT
			elif delta_pos.x < 0:
				calculated_dir = Direction.LEFT
		
		else:
			calculated_dir = Direction.DOWN
		
		set_facing_direction(calculated_dir)		

	last_position = position
	last_moving = moving


func set_facing_direction(dir):
	if dir != facing_direction:
		facing_direction = dir
		match facing_direction:
			Direction.UP:
				sprite.flip_h = false
				sprite.set_animation(animation_strings_walking[Direction.UP])
			Direction.RIGHT:
				sprite.flip_h = false
				sprite.set_animation(animation_strings_walking[Direction.RIGHT])
			Direction.DOWN:
				sprite.flip_h = false
				sprite.set_animation(animation_strings_walking[Direction.DOWN])
			Direction.LEFT:
				if has_dedicated_left_animation:
					sprite.flip_h = false
					sprite.set_animation(animation_strings_walking[Direction.LEFT])
				else:
					sprite.flip_h = true
					sprite.set_animation(animation_strings_walking[Direction.RIGHT])

func _on_animation_finished():
	if facing_direction == Direction.DOWN or facing_direction == Direction.UP:
		sprite.flip_h = !sprite.flip_h

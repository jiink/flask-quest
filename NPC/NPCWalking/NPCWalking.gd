extends AnimatedSprite

enum Direction { UP, RIGHT, DOWN, LEFT }

export(Direction) var facing_direction = Direction.DOWN setget set_facing_direction
export(bool) var auto_direction = true
export(bool) var interactable = true
export(bool) var up_down_periodic_mirroring = true # every other animation cycle for going up/down, mirror it for "more" frames?
export(float) var anim_speed_scale = 0.5

onready var last_position = position
var delta_pos = Vector2(0, 0)
var moving = false
var moving_threshold = 0.1

func _init():
	add_to_group("tick")
	if up_down_periodic_mirroring:
		connect("animation_finished", self, "_on_animation_finished")

func interact():
	if interactable:
		DiagHelper.start_talk(self)

func _tick():
	delta_pos = position - last_position

	var delta_pos_length = delta_pos.length()

	moving = delta_pos.length() > moving_threshold
	playing = moving

	speed_scale = delta_pos.length() * anim_speed_scale

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
		
		set_facing_direction(calculated_dir)		

	last_position = position


func set_facing_direction(dir):
	if dir != facing_direction:
		facing_direction = dir
		match facing_direction:
			Direction.UP:
				flip_h = false
				set_animation("up")
			Direction.LEFT:
				flip_h = true
				set_animation("right")
			Direction.RIGHT:
				flip_h = false
				set_animation("right")
			Direction.DOWN:
				flip_h = false
				set_animation("down")

func _on_animation_finished():
	if facing_direction == Direction.DOWN or facing_direction == Direction.UP:
		flip_h = !flip_h

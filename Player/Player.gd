extends KinematicBody2D

# this script could use some cleaning up... there's a lot of mish-mash and redundancy  

enum Direction { UP, RIGHTUP, RIGHT, RIGHTDOWN, DOWN, LEFTDOWN, LEFT, LEFTUP }

enum {
	PERSON,
	BOT,
	EXTERNAL
}

export(int, "PERSON", "BOT", "EXTERNAL") var controlled_by = PERSON setget set_controlled_by
export(int) var ground_speed = 60
export(int) var water_speed = 33
export(float) var sprintMultiplier

export(int) var player_number = 1

export (int, 0, 200) var push = 100

export(Direction) var extctrl_facing_direction = Direction.DOWN setget set_facing_direction
export(bool) var extctrl_auto_direction = true

var speed = ground_speed
var sprint = false
export(bool) var footstep_noise = true

export(int) var spritesheet_num_rows = 10; # for shaders

var motion = Vector2(0, 0)
var direction = Direction.RIGHT
var direction_enum_to_string = {
	Direction.UP : ["up", "up_idle"],
	Direction.RIGHTUP : ["rightup", "rightup_idle"],
	Direction.RIGHT : ["right", "right_idle"],
	Direction.RIGHTDOWN : ["rightdown", "rightdown_idle"],
	Direction.DOWN : ["down", "down_idle"],
	Direction.LEFTDOWN : ["leftdown", "leftdown_idle"],
	Direction.LEFT : ["left", "left_idle"],
	Direction.LEFTUP : ["leftup", "leftup_idle"],
}
var frozen = false
var invincible = false
var in_water = false

var extended = false

var previous_position = Vector2(0.0, 0.0)
var position_history = []
var in_water_history = []

var followed = true

onready var interactionZone = $Interaction/InteractionZone

var player_up = "up"
var player_down = "down"
var player_left = "left"
var player_right = "right"

var player_confirm = "confirm"
var player_cancel = "cancel"
var player_action = "action"

var new_step = false

onready var in_water_cutoff_shader = preload("res://Player/in_water_cutoff.shader")
onready var sprite = $AnimatedSprite

func _ready():
	$LightOccluder2D.visible = true
	
	yield(get_tree().create_timer(0.1), "timeout")
	clear_history()
	set_in_water(false)
	
	
func _process(delta):	
	if not extended:
		previous_position = position
		
		#if not get_owner().get_node("HUD/Diag").visible:
		if not frozen:
			get_inputs()
		else:
			# stop player when diag box is up.
			motion = Vector2(0,0)
	#	motion = motion.normalized()
	
	
		move_and_animate()
	
	#	if position != previous_position: 
	#		position_history.pop_back()
	#		position_history.push_front(position)
	#
	#		in_water_history.pop_back()
	#		in_water_history.push_front(in_water)
	
func move_and_animate():
	var movement = motion * speed if not sprint else motion * speed * sprintMultiplier
	move_and_slide(movement, Vector2(0, 0), false, 4, 0.785398, false) # needs no infinite intertia for pushing rigidbodies
	# after calling move_and_slide()
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("PushableProp"):
			collision.collider.apply_central_impulse(-collision.normal * push)

	change_izone_pos()
	
	$AnimatedSprite.set_animation(direction_enum_to_string[direction][int(not (motion.length() > 0))])
	
	if sprint:
		$AnimatedSprite.speed_scale = 2.73
	else:
		$AnimatedSprite.speed_scale = 1.3
	
	$AnimatedSprite.playing = true
	# if motion.length() > 0:
	# 	#$AnimatedSprite.playing = true
	# 	$AnimatedSprite.animation = ""
	# else:
	# 	#$AnimatedSprite.playing = false
	# 	$AnimatedSprite.frame = 0
	
	if $AnimatedSprite.frame == 1 or $AnimatedSprite.frame == 3 and not in_water:
		new_step = true
	
	if ($AnimatedSprite.frame == 0 or $AnimatedSprite.frame == 2) and new_step == true and not in_water and footstep_noise == true:
		$StepSound.pitch_scale = (randf() + 0.8) * 0.8
		$StepSound.play()
		new_step = false
		


func get_inputs():
	motion = Vector2(0, 0)
	
#	if Input.is_action_pressed("up"):
#		motion.y -= 1
#	if Input.is_action_pressed("down"):
#		motion.y += 1
	motion.y = Input.get_action_strength(player_down) - Input.get_action_strength(player_up)
#	if Input.is_action_pressed("left"):
#		motion.x -= 1
#	if Input.is_action_pressed("right"):
#		motion.x += 1
	motion.x = Input.get_action_strength(player_right) - Input.get_action_strength(player_left)
	motion = motion.normalized()
	
	var motion_simplified = Vector2(make_one(motion.x), make_one(motion.y))
#	motion_simplified.x = motion.x
	match motion_simplified:
		Vector2(0, -1):
			direction = Direction.UP
		Vector2(1, -1):
			direction = Direction.RIGHTUP
		Vector2(1, 0):
			direction = Direction.RIGHT
		Vector2(1, 1):
			direction = Direction.RIGHTDOWN
		Vector2(0, 1):
			direction = Direction.DOWN
		Vector2(-1, 1):
			direction = Direction.LEFTDOWN
		Vector2(-1, 0):
			direction = Direction.LEFT
		Vector2(-1, -1):
			direction = Direction.LEFTUP
	sprint = Input.is_action_pressed(player_action)
	
func _input(event):
	if(event.is_action_pressed(player_confirm)) and (not frozen):
		#interactionZone.monitoring = true
		#print(interactionZone.get_overlapping_areas())
		for area in interactionZone.get_overlapping_areas():
			if (area.name.to_lower() == "interaction") and area.get_parent().has_method("interact"):
				area.get_parent().interact()
				break
		get_tree().set_input_as_handled()
			
		
func change_izone_pos():
	match direction:
		Direction.UP:
			interactionZone.position = $Interaction/Up.position 
		Direction.RIGHTUP:
			interactionZone.position = $Interaction/Up.position + $Interaction/Right.position 
		Direction.RIGHT:
			interactionZone.position = $Interaction/Right.position 
		Direction.RIGHTDOWN:
			interactionZone.position = $Interaction/Down.position + $Interaction/Right.position 
		Direction.DOWN:
			interactionZone.position = $Interaction/Down.position 
		Direction.LEFTDOWN:
			interactionZone.position = $Interaction/Down.position + $Interaction/Left.position 
		Direction.LEFT:
			interactionZone.position = $Interaction/Left.position
		Direction.LEFTUP:
			interactionZone.position = $Interaction/Up.position + $Interaction/Left.position 

func set_in_water(setting):
	in_water = setting
	if setting:
		if has_node("InWaterEffect"):
			$InWaterEffect.visible = true
		else:
			add_child(load("res://Player/InWaterEffect.tscn").instance())
		var in_water_cutoff_material = ShaderMaterial.new()
		in_water_cutoff_material.shader = in_water_cutoff_shader
		in_water_cutoff_material.set_shader_param("row_count", spritesheet_num_rows)
		$AnimatedSprite.set_material(in_water_cutoff_material)
		$AnimatedSprite.offset.y = 7
		speed = water_speed
	else:
		$InWaterEffect.visible = false
		$AnimatedSprite.set_material(null)
		$AnimatedSprite.offset.y = 0
		speed = ground_speed

func go_invincible(time):
	invincible = true
	$AnimationPlayer.play("invincibility")
	$InvincibilityTimer.start(time)

func _on_InvincibilityTimer_timeout():
	invincible = false
	$AnimationPlayer.stop(true)

func do_floaty_text(s):
	var floaty_text = preload("res://Engine/FloatyText.tscn").instance()
	add_child(floaty_text)
	floaty_text.get_node("Label").text = s


func _on_HistoryTimer_timeout():
	if position != previous_position:
		position_history.pop_back()
		position_history.push_front(position)
		
		in_water_history.pop_back()
		in_water_history.push_front(in_water)
		
	$HistoryTimer.start(0.1)#1/Engine.get_frames_per_second())

func make_one(num):
	if num < 0:
		num = -1
	elif num > 0:
		num = 1
	return num

func set_frozen(choice = true, all = true): # freeze all players or just this one?
	frozen = choice
	if all:
		if global.get_player(2):
			global.get_player(2).frozen = choice
			global.get_player(2).motion = Vector2(0, 0)
			global.get_player(2).get_node("AnimatedSprite").playing = false
			global.get_player(2).get_node("AnimatedSprite").frame = 0
		if global.get_player(3):
			global.get_player(3).frozen = choice
			global.get_player(3).motion = Vector2(0, 0)
			global.get_player(3).get_node("AnimatedSprite").playing = false
			global.get_player(3).get_node("AnimatedSprite").frame = 0
	
func clear_history():
	position_history = []
	in_water_history = []
	for i in range(24):
		position_history.append(position)
		in_water_history.append(in_water)

# func _physics_process(delta):

# 	# after calling move_and_slide()
# 	for index in get_slide_count():
# 		var collision = get_slide_collision(index)
# 		if collision.collider.is_in_group("PushableProp"):
# 			collision.collider.apply_central_impulse(-collision.normal * push)

func set_controlled_by(new_controller):
	if new_controller == null: return
	controlled_by = new_controller
	print("Player now being controlled by %s" % controlled_by)
	match controlled_by:
		PERSON:
			remove_from_group("tick")
			set_process(true)
		BOT:
			pass
		EXTERNAL:
			add_to_group("tick")
			set_process(false)
		

# This (including the entire _tick function as of now) is used solely for the external control stuff
var extctrl_animation_strings_walking = [["up", "up_idle"],
	["rightup", "rightup_idle"],
	["right", "right_idle"],
	["rightdown", "rightdown_idle"],
	["down", "down_idle"],
	["leftdown", "leftdown_idle"],
	["left", "left_idle"],
	["leftup", "leftup_idle"],]
var extctrl_delta_pos = position
var extctrl_last_position = position
var extctrl_moving_threshold = 0.1
var extctrl_moving = false
var extctrl_last_moving = false
var extctrl_anim_speed_scale = 0.5
func _tick():
	print(sprite.get_animation())
	extctrl_delta_pos = position - extctrl_last_position

	var delta_pos_length = extctrl_delta_pos.length()

	extctrl_moving = extctrl_delta_pos.length() > extctrl_moving_threshold
	sprite.playing = extctrl_moving

	sprite.speed_scale = extctrl_delta_pos.length() * extctrl_anim_speed_scale
		
	#if (extctrl_moving) and (not extctrl_last_moving):
		#sprite.set_animation(extctrl_animation_strings_walking[extctrl_facing_direction][0])#int(not (extctrl_moving))])

	if extctrl_moving and extctrl_auto_direction:

		var calculated_dir

		# if abs(extctrl_delta_pos.y) > abs(extctrl_delta_pos.x):
		# 	if extctrl_delta_pos.y > 0:
		# 		calculated_dir = Direction.DOWN
		# 	elif extctrl_delta_pos.y < 0:
		# 		calculated_dir = Direction.UP
				
		# elif abs(extctrl_delta_pos.x) > abs(extctrl_delta_pos.y):
		# 	if extctrl_delta_pos.x > 0:
		# 		calculated_dir = Direction.RIGHT
		# 	elif extctrl_delta_pos.x < 0:
		# 		calculated_dir = Direction.LEFT
		
		var delta_pos_simplified = Vector2(make_one(extctrl_delta_pos.x), make_one(extctrl_delta_pos.y))
		#	delta_pos_simplified.x = motion.x
		print(delta_pos_simplified)
		match delta_pos_simplified:
			Vector2(0, -1):
				calculated_dir = Direction.UP
			Vector2(1, -1):
				calculated_dir = Direction.RIGHTUP
			Vector2(1, 0):
				calculated_dir = Direction.RIGHT
			Vector2(1, 1):
				calculated_dir = Direction.RIGHTDOWN
			Vector2(0, 1):
				calculated_dir = Direction.DOWN
			Vector2(-1, 1):
				calculated_dir = Direction.LEFTDOWN
			Vector2(-1, 0):
				calculated_dir = Direction.LEFT
			Vector2(-1, -1):
				calculated_dir = Direction.LEFTUP
			Vector2(0, 0):
				calculated_dir = Direction.DOWN

		set_facing_direction(calculated_dir)		

	extctrl_last_position = position
	extctrl_last_moving = extctrl_moving

func set_facing_direction(dir):
	if (dir != extctrl_facing_direction) and (dir != null):
		extctrl_facing_direction = dir
		
		sprite.set_animation(extctrl_animation_strings_walking[dir][int(not extctrl_moving)])#(motion.length() > 0))])
		# match extctrl_facing_direction:
		# 	Direction.UP:
		# 		sprite.set_animation("up")
		# 	Direction.RIGHT:
		# 		sprite.set_animation("right")
		# 	Direction.DOWN:
		# 		sprite.set_animation("down")
		# 	Direction.LEFT:
		# 		sprite.set_animation("left")


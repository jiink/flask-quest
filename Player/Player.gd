extends KinematicBody2D

export(int) var ground_speed = 60
export(int) var water_speed = 33
export(float) var sprintMultiplier

export(int) var player_number = 1

var speed = ground_speed
var sprint = false
var motion = Vector2(0, 0)
var direction = "right"
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

func _ready():
	$LightOccluder2D.visible = true
	
	yield(get_tree().create_timer(0.1), "timeout")
	for i in range(24):
		position_history.append(position)
		in_water_history.append(in_water)
#	print("UH: %s" % Engine.get_frames_per_second())
	
	
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
	move_and_slide(movement)
	change_izone_pos()
		
	$AnimatedSprite.animation = direction
	if sprint:
		$AnimatedSprite.speed_scale = 2.73
	else:
		$AnimatedSprite.speed_scale = 1.3
	if motion.length() > 0:
		$AnimatedSprite.playing = true
	else:
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 0
	


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
			direction = "up"
		Vector2(1, -1):
			direction = "rightup"
		Vector2(1, 0):
			direction = "right"
		Vector2(1, 1):
			direction = "rightdown"
		Vector2(0, 1):
			direction = "down"
		Vector2(-1, 1):
			direction = "leftdown"
		Vector2(-1, 0):
			direction = "left"
		Vector2(-1, -1):
			direction = "leftup"
	sprint = Input.is_action_pressed(player_action)
	
	if Input.is_action_just_pressed(player_confirm):
		#interactionZone.monitoring = true
		#print(interactionZone.get_overlapping_areas())
		for area in interactionZone.get_overlapping_areas():
			
			if (area.name.to_lower() == "interaction") and area.get_parent().has_method("interact"):
				area.get_parent().interact()
				break
				
		
func change_izone_pos():
	match direction:
		"up":
			interactionZone.position = $Interaction/Up.position 
		"upright":
			interactionZone.position = $Interaction/Up.position + $Interaction/Right.position 
		"right":
			interactionZone.position = $Interaction/Right.position 
		"downright":
			interactionZone.position = $Interaction/Down.position + $Interaction/Right.position 
		"down":
			interactionZone.position = $Interaction/Down.position 
		"downleft":
			interactionZone.position = $Interaction/Down.position + $Interaction/Left.position 
		"left":
			interactionZone.position = $Interaction/Left.position
		"upleft":
			interactionZone.position = $Interaction/Up.position + $Interaction/Left.position 

func set_in_water(setting):
	in_water = setting
	if setting:
		if has_node("InWaterEffect"):
			$InWaterEffect.visible = true
		else:
			add_child(load("res://Player/InWaterEffect.tscn").instance())
		$AnimatedSprite.offset.y = 4
		speed = water_speed
	else:
		$InWaterEffect.visible = false
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
	floaty_text.text = s


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
	if all and global.get_player(2):
		global.get_player(2).frozen = choice
		global.get_player(2).motion = Vector2(0, 0)
		global.get_player(2).get_node("AnimatedSprite").playing = false
		global.get_player(2).get_node("AnimatedSprite").frame = 0
	

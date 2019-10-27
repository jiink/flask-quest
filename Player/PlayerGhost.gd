extends KinematicBody2D

export (int) var speed
export (float) var sprintMultiplier

var sprint = false
var motion = Vector2(0, 0)
var direction = "right"
var frozen = false
var invincible = false
var in_water = false

var previous_position
var position_history = []
var in_water_history = []

var followed = true

onready var interactionZone = $Interaction/InteractionZone

func _ready():
	$LightOccluder2D.visible = true
	
	yield(get_tree().create_timer(0.1), "timeout")
	for i in range(24):
		position_history.append(position)
		in_water_history.append(in_water)
	
	
	
func _process(delta):	
	
	previous_position = position
	
	#if not get_owner().get_node("HUD/Diag").visible:
	if not frozen:
		get_inputs()
	else:
		# stop player when diag box is up.
		motion = Vector2(0,0)
	motion = motion.normalized()
	
	var movement = motion * speed if not sprint else motion * speed * sprintMultiplier
	move_and_slide(movement)
	change_izone_pos()
		
	
	
	if position != previous_position:
		position_history.pop_back()
		position_history.push_front(position)
		
		in_water_history.pop_back()
		in_water_history.push_front(in_water)
	
	
func get_inputs():
	motion = Vector2(0, 0)
	if Input.is_action_pressed("up"):
		motion.y -= 1
	if Input.is_action_pressed("down"):
		motion.y += 1
		
	if Input.is_action_pressed("left"):
		motion.x -= 1
	if Input.is_action_pressed("right"):
		motion.x += 1
		
	match motion:
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
	sprint = Input.is_action_pressed("x")
	
	if Input.is_action_just_pressed("a"):
		#interactionZone.monitoring = true
		#print(interactionZone.get_overlapping_areas())
		for area in interactionZone.get_overlapping_areas():
			if area.get_parent().has_method("interact"):
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
		speed /= 1.8
	else:
		$InWaterEffect.visible = false
		$AnimatedSprite.offset.y = 0
		speed *= 1.8

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

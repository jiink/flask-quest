extends KinematicBody2D

export (int) var speed
export (float) var sprintMultiplier

var sprint = false
var motion = Vector2(0, 0)
var direction = "right"

onready var interactionZone = $Interaction/InteractionZone

func _process(delta):
	if not get_owner().get_node("HUD/Diag").visible:
		get_inputs()
	motion = motion.normalized()
	
	var movement = motion * speed if not sprint else motion * speed * sprintMultiplier
	move_and_slide(movement)
	change_izone_pos()
		
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
			direction = "upright"
		Vector2(1, 0):
			direction = "right"
		Vector2(1, 1):
			direction = "downright"
		Vector2(0, 1):
			direction = "down"
		Vector2(-1, 1):
			direction = "downleft"
		Vector2(-1, 0):
			direction = "left"
		Vector2(-1, -1):
			direction = "upleft"
			
	sprint = Input.is_action_pressed("x")
	
	if Input.is_action_just_pressed("a"):
		#interactionZone.monitoring = true
		#print(interactionZone.get_overlapping_areas())
		for area in interactionZone.get_overlapping_areas():
			if area.get_owner().has_method("interact"):
				area.get_owner().interact()
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

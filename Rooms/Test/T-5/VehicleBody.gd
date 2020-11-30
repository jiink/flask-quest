extends VehicleBody

const STEER_SPEED = 0.4
const STEER_LIMIT = 0.3

var steer_target = 0

export var engine_force_value = 40

var currently_flipping = false
onready var tween = $Tween
onready var steeringwheel = $"CanvasLayer/car_interior/steeringwheel_frames"

func _input(event):
	if event.is_action_pressed("cancel"):
		$HonkAudio.play()

func _physics_process(delta):
#	flip the vehicle upright if it's flipped over
	if (rotation.x > 0.8 or rotation.x < -0.8) or (rotation.z > 0.8 or rotation.z < -0.8) and \
	(not currently_flipping):
		currently_flipping = true
		flip_vehicle()
	var fwd_mps = transform.basis.xform_inv(linear_velocity).x
	
	steer_target = Input.get_action_strength("left") - Input.get_action_strength("right")
	steer_target *= STEER_LIMIT
	
	if Input.is_action_pressed("confirm"):
		engine_force = engine_force_value
	else:
		engine_force = 0
	
	if Input.is_action_pressed("down"):
		if (fwd_mps >= -1):
			engine_force = -engine_force_value
		else:
			brake = 1
	else:
		brake = 0.0
	
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)

	if Input.is_action_pressed("right"):
		steeringwheel.frame = 1
	elif Input.is_action_pressed("left"):
		steeringwheel.frame = 2
	else:
		steeringwheel.frame = 0

func flip_vehicle():
	$AlertAudio.playing = true
	var first_pos = translation
	var first_rotation_y = rotation.y
	tween.interpolate_property(self, "translation", \
	 null, first_pos + Vector3(0, 2, 0), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.interpolate_property(self, "rotation", \
	 null, Vector3(0, first_rotation_y, 0), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")
	angular_velocity = Vector3(0,0,0)
	linear_velocity = Vector3(0,0,0)
	currently_flipping = false

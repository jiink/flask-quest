extends VehicleBody

var torque_strength = 300
var propulsion_strength = 5

const PI_2 = PI/2

func _physics_process(delta):
#	var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
#	apply_torque_impulse(direction * torque_strength)
#
	if Input.is_action_pressed("confirm"):
		engine_force = 500
#		apply_impulse(Vector3(0,0,0), Vector3(0,0,0))
#			 Vector2(cos(rotation - PI_2) * propulsion_strength, sin(rotation - PI_2) * propulsion_strength))
#
#func _process(delta):
#	if Input.is_action_pressed("confirm"):
#		$RocketLight.energy = 1
#		$RocketParticles.emitting = true
#	else:
#		$RocketLight.energy = 0
#		$RocketParticles.emitting = false

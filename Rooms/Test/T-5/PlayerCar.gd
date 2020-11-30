extends RigidBody

export(float) var torque_strength
export(float) var propulsion_strength

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
const PI_2 = PI/2

func _physics_process(delta):
	var direction = Vector3(0, (Input.get_action_strength("left") - Input.get_action_strength("right")) * torque_strength, 0)
	angular_velocity *= Vector3(1, 0.9, 1)	
	if linear_velocity.length() >= 0.2:
		apply_torque_impulse(direction)
	if Input.is_action_pressed("confirm"):
		apply_impulse(Vector3(0, 0, 0), get_global_transform().basis.z.normalized() * propulsion_strength)

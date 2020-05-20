extends RigidBody2D

export(bool) var charged = false
var locked = false

var need_to_move = false
var new_move_position = Vector2(0, 0)

func _ready():
	set_charged(charged)



func set_charged(choice):
	charged = choice
	$Sprite.frame = 1 if choice else 0


func set_locked(choice):
	locked = choice
	if locked:
		mass = 25270 # too heavy
	else:
		mass = 20.43
	# print("battery mass is now %s" % mass)

func _tick():
	# uhh to prevent jittering when the camera moves and this is still
	var the_bad = Vector2(int(position.x) - position.x, int(position.y) - position.y)
	$Sprite.position = the_bad

func _integrate_forces(state):
	
	if need_to_move:
		var t = state.get_transform()
		t.origin.x = new_move_position.x
		t.origin.y = new_move_position.y
		state.set_transform(t)

		set_linear_velocity(Vector2(0, 0))

		need_to_move = false


func move_to(new_pos):
	need_to_move = true
	new_move_position = new_pos

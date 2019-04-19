extends Area2D

export(bool) var face_center = false
export(NodePath) var face_node

export(float) var speed = 100
export(float) var speed_change = 1

var vec

func _ready():
	if face_center:
		if get_parent().name == "DodgerField":
			look_at(get_parent().position)
		else:
			print("Warning: Projectile couldn't face center")
	elif face_node != null:
		look_at(get_node(face_node).position)
	
	if face_center and face_node != null:
		print("Warning: Can't face two places at once; facing center")
	
	vec = Vector2(speed, 0).rotated(rotation)
	
func _process(delta):
	position += vec * delta
	vec *= speed_change
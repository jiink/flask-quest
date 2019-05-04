extends Area2D

#TODO: MAKE BULLET DESTROY SELF!!!!!!!!!!11

export(bool) var face_center = false
export(NodePath) var face_node
enum {NORMAL, GREEN, ORANGE}
export(int, "NORMAL", "GREEN", "ORANGE") var type
export(int) var damage = 15

export(float) var speed = 100
export(float) var speed_change = 1

var vec

func _ready():

	connect("area_entered", self, "area_entered")
	
	if face_center:
		if $"../..".name == "DodgerField":
			look_at($"../..".position)
		else:
			print("Warning: Projectile couldn't face field; trying other way")
			look_at(Vector2(192, 108))
	elif face_node != null:
		look_at(get_node(face_node).position)
		
	if face_center and face_node != "":
		print("Warning: Can't face two places at once; facing center")
	
	vec = Vector2(speed, 0).rotated(rotation)
	
	match type:
		NORMAL:
			pass
		GREEN:
			set_modulate(Color("72D031"))
		ORANGE:
			set_modulate(Color("F68F31"))
		_:
			print("Error: Invalid projectile type; setting to NORMAL")
			type = NORMAL
	
	
func _process(delta):
	position += vec * delta
	vec *= speed_change
	
func area_entered(area):
	print("AREA ENTERRRRED\nsomething was hit...")
	if area.get_parent().name == "GreenSprite" and type != GREEN:
		print("... it was green")
		if has_node("../../.."):
			get_node("../../..").call("hurt", "green", damage)
		queue_free()
	elif area.get_parent().name == "OrangeSprite" and type != ORANGE:
		print("... it was orange")
		if has_node("../../.."):
			get_node("../../..").call("hurt", "orange", damage)
		queue_free()
extends "res://Engine/Battle/StatusEffects/Offensiveness.gd"

func _ready():
#	print("Hi, I'm %s, and I now exist" % name)
	damage = 2 * level 
	duration = level
	
	if get_parent().get_class() == "Node2D":
		if get_parent().has_node("Sprite"):
			
			if get_parent().get_node("Sprite").get_material() == null:
				var new_material = ShaderMaterial.new()
				get_parent().get_node("Sprite").set_material(new_material)
				
			get_parent().get_node("Sprite").get_material().set_shader(load("res://Engine/fire.shader"))
		else:
			print('warning, get_parent() doesn\'t have "Sprite"')
	else:
		print("Error, error: status effect get_parent() invalid. get_parent() is %s" % get_parent().get_class())

func do_effect():
#	print("Hi i'm a status effect and now i'm doing my thing")
	get_parent().get_hurt(damage + randi() % 10)

func remove():
	get_parent().get_node("Sprite").get_material().set_shader(null)
	queue_free()

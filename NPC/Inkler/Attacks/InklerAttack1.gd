extends Node2D

onready var ink_scene = load("res://Engine/Battle/Dodger/Projectiles/Inkdrop.tscn")
var active = true

func _on_Timer_timeout():
	if active:
		emit_ink()

func emit_ink():
	var ink_instance = ink_scene.instance()
	add_child(ink_instance)
	ink_instance.position = $InkEmissionPoint.position
	ink_instance.vec = Vector2(rand_range(-150, -100), rand_range(-150, -100))
	
#	var its_scale = rand_range(0.1, 0.5)
#	ink_instance.scale.x = its_scale
#	ink_instance.scale.y = ink_instance.scale.x
#	ink_instance.get_node("Particles2D").scale = its_scale


func _on_MainTimer_timeout():
	active = false

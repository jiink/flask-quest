extends Node2D

signal chem_visual_completed

#func _ready():
#	connect("chem_visual_completed",
#			get_parent().get_node("PouringEvent"), "on_chem_visual_completed")

func done():
	print("chem_visual_completed emmiteeed")
	emit_signal("chem_visual_completed")
	queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	done()

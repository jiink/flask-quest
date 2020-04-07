extends "res://Engine/Battle/StatusEffects/Offensiveness.gd"

func _ready():
	
	# victim must be metal foe
	if not(get_parent() in get_tree().get_nodes_in_group("foes")) or \
			not("metal" in get_parent().types):
				queue_free()
		
	
	damage = 3.5 * level 
	duration = level
	
func do_effect():
	get_parent().get_hurt(damage + randi() % 10)

func remove():
	queue_free()

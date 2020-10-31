extends StaticBody2D

export(int) var bell_number
onready var root_node = get_owner()

func interact():
	$AnimationPlayer.play("ring")
	root_node.move_boat(bell_number)

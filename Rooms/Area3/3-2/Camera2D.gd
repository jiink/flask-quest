extends Camera2D

onready var player = get_node("../Player")

var clamped_pos_y

func _process(delta):
	clamped_pos_y = clamp(player.position.y - 32, -11677, 258)
	position.y = clamped_pos_y

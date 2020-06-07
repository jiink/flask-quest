extends Sprite

export (Array, NodePath) var required_sockets
var activated_sockets = 0

func _ready():
	for everything in required_sockets:
		get_node(everything).connect("battery_socket_filled", self, "battery_socket_filled")
	
func battery_socket_filled():
	activated_sockets += 1
	if activated_sockets >= required_sockets.size():
		open()
	
func open():
	$AnimationPlayer.play("open")


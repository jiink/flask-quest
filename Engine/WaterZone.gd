extends Area2D

func _ready():
	if get_child(0).get_class() == "CollisionShape2D":
		connect("body_entered", self, "on_body_entered")
		connect("body_exited", self, "on_body_exited")
	else:
		print("Warning, %s has no CollisionShape2D" % self.name)

func on_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player"):
		body.set_in_water(true)

func on_body_exited(body):
	if body in get_tree().get_nodes_in_group("Player"):
		body.set_in_water(false)

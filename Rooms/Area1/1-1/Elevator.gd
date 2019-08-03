extends Node2D

var state = false

func _ready():
	$Doors.frame = 0

func interact():
	if ItemManager.inventory.has("elevator_card"):
		set_elevator_open(true)
	else:
		get_tree().get_nodes_in_group("Player")[0].do_floaty_text("It's locked.")

func set_elevator_open(new_state):
	if new_state == true:
		if state == false:
			get_node("AnimationPlayer").play("open_doors")
			yield(get_node("AnimationPlayer"), "animation_finished")
			get_node("ClosedBody/CollisionShape2D").disabled = true
	else:
		if state == true:
			get_node("AnimationPlayer").play_backwards("open_doors")
			get_node("ClosedBody/CollisionShape2D").disabled = false
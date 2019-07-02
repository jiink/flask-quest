extends "res://Rooms/TemplateRoom.gd"

var lab_door_open = false

var SAVE_KEY = "1-1_"

func save(save_game):
	save_game.data[SAVE_KEY + "lab_door_open"] = lab_door_open
	
func load(save_game):
	lab_door_open = save_game.data[SAVE_KEY + "lab_door_open"]
	update_lab_door()
	
func update_lab_door():
	var lab_door = $YSort/Props/LabDoor
	if lab_door_open:
		lab_door.get_node("closed").visible = false
		lab_door.get_node("open").visible = true
		lab_door.get_node("ClosedCollision/CollisionShape2D").disabled = true
	else:
		lab_door.get_node("closed").visible = true
		lab_door.get_node("open").visible = false
		lab_door.get_node("ClosedCollision/CollisionShape2D").disabled = false

extends "res://Rooms/TemplateRoom.gd"

var lab_door_open = false
var orange_state = 2

var SAVE_KEY = "1-1_"

func save(save_game):
	save_game.data[SAVE_KEY + "lab_door_open"] = lab_door_open
	save_game.data[SAVE_KEY + "orange_state"] = orange_state
	
func load(save_game):
	lab_door_open = save_game.data[SAVE_KEY + "lab_door_open"]
	update_lab_door()
	set_orange_state(save_game.data[SAVE_KEY + "orange_state"])
	
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
		
func set_orange_state(i):
	var disabled_orange = $YSort/Props/tableL/OrangeDisabled
	var npc_orange = $YSort/OrangeNPC
	
	disabled_orange.visible = false
	npc_orange.visible = false
	match i:
		2:
			disabled_orange.visible = true
		1:
			npc_orange.visible = true
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
	npc_orange.get_node("StaticBody2D/CollisionShape2D2").set_deferred("disabled", true)
	match i:
		2:
			disabled_orange.visible = true
		1:
			npc_orange.visible = true
			npc_orange.get_node("StaticBody2D/CollisionShape2D2").set_deferred("disabled", false)
			disabled_orange.queue_free()

func start_brainjar_event():
	var brainjar_npc = $YSort/BrainJarNPC
	brainjar_npc.visible = true
	# add screenshake at some point
	var m = $MinimanDoorEvent
	m.get_node("Flash").visible = true
	m.get_node("Tween").interpolate_property(m.get_node("Flash"), "modulate",
			Color("FFFFFFFF"), Color("00FFFFFF"),
			0.8, Tween.TRANS_LINEAR, Tween.EASE_IN)
	m.get_node("Tween").start()
	yield(get_tree().create_timer(0.1), "timeout")
	DiagHelper.start_talk(brainjar_npc)
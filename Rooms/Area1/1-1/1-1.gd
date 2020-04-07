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
		if get_node("YSort").has_node("Miniman"):
			$YSort/Miniman.queue_free()
	else:
		lab_door.get_node("closed").visible = true
		lab_door.get_node("open").visible = false
		lab_door.get_node("ClosedCollision/CollisionShape2D").disabled = false
		
func set_orange_state(i):
	print("setting orange state from %s to %s" % [orange_state, i])
	orange_state = i
	var disabled_orange = $YSort/Props/tableL/OrangeDisabled
	var npc_orange = $YSort/OrangeNPC
	if disabled_orange:
		disabled_orange.visible = false
	npc_orange.visible = false
	npc_orange.get_node("StaticBody2D/CollisionShape2D2").set_deferred("disabled", true)
	match i:
		2:
			disabled_orange.visible = true
#			PlayerStats.party_members = []
		1:
			npc_orange.visible = true
			npc_orange.get_node("StaticBody2D/CollisionShape2D2").set_deferred("disabled", false)
			npc_orange.get_node("Interaction/CollisionShape2D").set_deferred("disabled", false)
			if disabled_orange: disabled_orange.queue_free()
#			PlayerStats.party_members = []
		0:
			npc_orange.visible = false
			npc_orange.get_node("StaticBody2D/CollisionShape2D2").set_deferred("disabled", true)
			npc_orange.get_node("Interaction/CollisionShape2D").set_deferred("disabled", true)
			if disabled_orange: disabled_orange.queue_free()
			var orange_follower = preload("res://Player/Orange.tscn").instance()
			$YSort.add_child(orange_follower)
#			PlayerStats.party_members = ["orange"]
			$YSort.add_child(load("res://Player/Orange.tscn").instance())


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
	# get the miniman item equipped
	
	ItemManager.inventory.remove("miniman_item")
	ItemManager.loadout.remove("miniman_item")
	ItemManager.loadout[0] = "miniman_item"

func on_brainjar_defeat():
	set_orange_state(0)
	

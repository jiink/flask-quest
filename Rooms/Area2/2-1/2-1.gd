extends "res://Rooms/TemplateRoom.gd"

var malus_door_locked = true

var SAVE_KEY = "2-1_"

enum { SIGN_CLOSED, SIGN_OPEN }

func _ready():
	$YSort/MapMachine.connect("map_machine_opened", self, "_on_map_machine_opened")

func save(save_game):
	save_game.data[SAVE_KEY + "malus_door_locked"] = malus_door_locked
	
func load(save_game):
	malus_door_locked = save_game.data[SAVE_KEY + "malus_door_locked"]
	update_malus_door(malus_door_locked)

func update_malus_door(state):
	malus_door_locked = state
	
	if malus_door_locked:
		$MalusEntrance/DoorSign.frame = SIGN_CLOSED
		$MalusEntrance/StaticBody2D/CollisionShape2D.disabled = false
		$MalusEntrance/Interaction/CollisionShape2D.disabled = false
		
	else:
		$MalusEntrance/DoorSign.frame = SIGN_OPEN
		$MalusEntrance/StaticBody2D/CollisionShape2D.disabled = true
		$MalusEntrance/Interaction/CollisionShape2D.disabled = true
		# hey why isnt that working, screw it just blow it up
		$MalusEntrance/StaticBody2D.queue_free()
		$MalusEntrance/Interaction.queue_free()

func _on_map_machine_opened():
	# now that the player viewed the map machine, unlock the doors to malus
	update_malus_door(false)


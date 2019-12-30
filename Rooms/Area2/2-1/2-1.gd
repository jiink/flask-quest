extends "res://Rooms/TemplateRoom.gd"

var malus_door_locked = true

var SAVE_KEY = "2-1_"

enum { SIGN_CLOSED, SIGN_OPEN }

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
		$MalusEntrance/Area2D/CollisionShape2D.disabled = false
		
	else:
		$MalusEntrance/DoorSign.frame = SIGN_OPEN
		$MalusEntrance/StaticBody2D/CollisionShape2D.disabled = true
		$MalusEntrance/Area2D/CollisionShape2D.disabled = true
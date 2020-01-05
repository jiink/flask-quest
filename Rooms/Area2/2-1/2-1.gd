extends "res://Rooms/TemplateRoom.gd"

var malus_door_locked = true
var manhole_event_happened = false

var SAVE_KEY = "2-1_"

enum { SIGN_CLOSED, SIGN_OPEN }

func _ready():
	$YSort/MapMachine.connect("map_machine_opened", self, "_on_map_machine_opened")
	
	
	# do manhole event when they come out of malus
	var should_do_manhole_event = GameSaver.save_game.data["4-1_been_in_malus"] and (not manhole_event_happened)
	print("should_do_manhole_event: %s" % should_do_manhole_event)
#	print("it already happened: %s" % manhole_event_happened)
	if should_do_manhole_event:
		do_manhole_event()
	else:
#		if manhole_event_happened:
		update_manhole(manhole_event_happened)
	
	
func save(save_game):
	save_game.data[SAVE_KEY + "malus_door_locked"] = malus_door_locked
	save_game.data[SAVE_KEY + "manhole_event_happened"] = manhole_event_happened
	
func load(save_game):
	malus_door_locked = save_game.data[SAVE_KEY + "malus_door_locked"]
	manhole_event_happened = save_game.data[SAVE_KEY + "manhole_event_happened"]
	update_malus_door(malus_door_locked)

func update_manhole(state): # true open false close
	if state:
		$SpecialManhole/Sprite.frame = 19 # looks open
		$SpecialManhole/PortalToSewer/CollisionShape2D.disabled = false
	else:
		$SpecialManhole/Sprite.frame = 0 # looks closed
		$SpecialManhole/Particles2D.emitting = false
		$SpecialManhole/PortalToSewer/CollisionShape2D.disabled = true
	

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

func _on_map_machine_opened():
	# now that the player viewed the map machine, unlock the doors to malus
	update_malus_door(false)

func do_manhole_event():
	manhole_event_happened = true
	print("doing manhole event")
	$SpecialManhole/AnimationPlayer.play("open")
	$SpecialManhole/PortalToSewer/CollisionShape2D.disabled = false
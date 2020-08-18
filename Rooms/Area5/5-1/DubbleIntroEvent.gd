extends Node2D

var SAVE_KEY = "5-1_dubble_intro_event_"
var occured = false

func save(save_game):
	save_game.data[SAVE_KEY + "occured"] = occured
	
	
func load(save_game):
	occured = save_game.data[SAVE_KEY + "occured"]
	suicide(occured)
	if not occured:
		setup()

func suicide(state):
	if state:
		queue_free()
	
func setup():
	$OverlayAnimator.play("wake_up")
	yield(get_tree().create_timer(3), "timeout")
	DiagHelper.start_talk(self, "OrangeTalk")
		
func dubble_walk_by():
	$CharacterMovement.play("dubble_walk_by")

func door_knock():
	$DoorKnockAudio.playing = true
#	Orange runs to the corner of the room (he's afraid to open the door!)

func green_wake():
	print("**************Let the player move around now.***********")
#	Animate the player getting out of bed and give them control

func orange_run_to_window():
	pass
#	Orange quickly runs to the window.

func orange_turn():
	pass
#	Orange turns while he talks

func _on_ActivateArea_body_entered(body):
	if body == global.get_player():
		$CharacterMovement.play("dubble_enter_room")
#		Player backs up, Dubble talks w/ Green+Orange
		yield(get_tree().create_timer(3), "timeout")
		DiagHelper.start_talk(self, "DubbleTalk")
		$"ActivateArea/CollisionShape2D".set_deferred("disabled", true)

func dubble_intro_end():
	occured = true
#	dubble walks out of room and is transported to behind his desk. Player can now move freely.


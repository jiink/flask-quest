extends Node2D

var SAVE_KEY = "5-1_dubble_intro_event_"
var occured = false
var green
var orange
var orange_original_controller

func save(save_game):
	save_game.data[SAVE_KEY + "occured"] = occured
	
	
func load(save_game):
	occured = save_game.data[SAVE_KEY + "occured"]

	prepare_suicide(occured)
	if not occured:
		setup()

func prepare_suicide(state): # Places Dubble behind his desk and commits suicide
#	print("STATE? THE STATE IS %s" % state)
	if state:
		$ColorOverlay.visible = false
		var dubble = get_node("../YSort/Dubble")
		$CharacterMovement.play("idle_behind_desk")
#		print("HEY, WE GOT HERE. CHARACTERMOVEMENT SHOULD DO ITS THING NOW.")
		dubble.facing_direction = dubble.Direction.DOWN
		$"ActivateArea/CollisionShape2D".set_deferred("disabled", true)
		
func setup():
	green = global.get_player(1)
	orange = global.get_player(2)
	orange_original_controller = orange.controlled_by
	orange.controlled_by = orange.EXTERNAL
	green.controlled_by = green.EXTERNAL
	MusicManager.change_music("res://Rooms/Area5/Assets/ontoglasstown-07.ogg", true, 0)
	$OverlayAnimator.play("wake_up")
	yield(get_tree().create_timer(3), "timeout")
	DiagHelper.start_talk(self, "OrangeTalk")
	$CharacterMovement.play("idle_hide_behind_wall")
	
func dubble_walk_by():
	$CharacterMovement.play("dubble_walk_by")

func door_knock():
	$DoorKnockAudio.playing = true
#	Orange runs to the corner of the room (he's afraid to open the door!)

func green_wake():
	print("**************Let the player move around now.***********")
	$CharacterMovement.play("green_exit_bed")
	green.controlled_by = green.PERSON

func orange_run_to_window():
	orange.controlled_by = orange.EXTERNAL
	$CharacterMovement.play("orange_run_to_window")
#	Orange quickly runs to the window.

func orange_turn():
	orange.extctrl_facing_direction = orange.Direction.DOWN

func _on_ActivateArea_body_entered(body):
	if body == global.get_player():
		$CharacterMovement.play("dubble_enter_room")
#		Player backs up, Dubble talks w/ Green+Orange
		$Tween.interpolate_property(global.get_player(1), "position", \
	 	null, global.get_player(1).position + Vector2(0, -16), 0.7, \
		Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		yield(get_tree().create_timer(3), "timeout")
		DiagHelper.start_talk(self, "DubbleTalk")
		$"ActivateArea/CollisionShape2D".set_deferred("disabled", true)

func dubble_intro_end():
	occured = true
	orange.controlled_by = orange_original_controller
	$CharacterMovement.play("dubble_exit_room")
#	dubble walks out of room and is transported to behind his desk. Player can now move freely.

func set_time_day():
	get_node("..").fade_time_of_day(1)

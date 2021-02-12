extends YSort


export(float) var travel_time = 1
onready var green = global.get_player(1)
onready var orange = global.get_player(2)
onready var ribbit = global.get_player(3)

onready var door_animator = get_node("DoorAnimator")
onready var door_trigger_bottom = get_node("DoorAreaBottom/CollisionShape2D")
onready var door_trigger_top = get_node("DoorAreaTop/CollisionShape2D")

onready var trigger_bottom = get_node("TriggerAreaBottom/TriggerBottom")
onready var trigger_top = get_node("TriggerAreaTop/TriggerTop")
onready var position_bottom = get_node("PosBottom").position
onready var position_top = get_node("PosTop").position
onready var true_position_top = position_top + position
onready var true_position_bottom = position_bottom + position

onready var bottom_signal = $elevator_signal_bottom
onready var top_signal = $elevator_signal_top
onready var bell_player = $AudioStreamPlayer

var player_in_elevator = false
var opened_door = Floor.NONE

var close_audio = preload("res://SoundEffects/hydraulic_stop.wav")
var open_audio = preload("res://SoundEffects/hydraulic.wav")


enum Direction {
	UP,
	DOWN
}

enum Floor {
	BOTTOM,
	TOP,
	NONE
}

func _on_TriggerAreaBottom_body_entered(body):
	if body == global.get_player():
		move_player(Direction.UP)

func _on_TriggerAreaTop_body_entered(body):
	if body == global.get_player():
		move_player(Direction.DOWN)

func move_player(chosen_direction):
	player_in_elevator = true
	
	var original_orange_controller = orange.controlled_by
	var original_ribbit_controller = ribbit.controlled_by
	door_trigger_bottom.set_deferred("disabled", true)
	door_trigger_top.set_deferred("disabled", true)
	trigger_bottom.set_deferred("disabled", true)
	trigger_top.set_deferred("disabled", true)
	
#	Figure out where player entered and where they're going
	var first_pos
	var second_pos
	var player_floor
	match chosen_direction:
		Direction.UP:
			first_pos = true_position_bottom
			second_pos = true_position_top
			player_floor = Floor.BOTTOM
		Direction.DOWN:
			first_pos = true_position_top
			second_pos = true_position_bottom
			player_floor = Floor.TOP
			
#	move the player to the center of the shaft
	orange.controlled_by = orange.EXTERNAL
	green.controlled_by = green.EXTERNAL

	$Tween.interpolate_property(global.get_player(1), "position", \
	 null, first_pos, 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property(global.get_player(2), "position", \
	 null, first_pos + Vector2(7,7), 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	orange.extctrl_facing_direction = orange.Direction.DOWN
	green.extctrl_facing_direction = green.Direction.DOWN
	yield(get_tree().create_timer(0.2), "timeout")
######

	$DoorAudio.set_stream(close_audio)
	bottom_signal.frame = 1
	top_signal.frame = 1
	match player_floor:
		Floor.BOTTOM:
			door_animator.play_backwards("open_bottom")
		Floor.TOP:
			door_animator.play_backwards("open_top")
	yield(door_animator, "animation_finished")
	
	green.visible = false
	orange.visible = false
	ribbit.visible = false
	ribbit.controlled_by = ribbit.EXTERNAL
	
#	move the invisible players to the top of the shaft

	$Tween.interpolate_property(green, "position", \
	 null, second_pos, travel_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(orange, "position", \
	 null, second_pos + Vector2(7,7), travel_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(ribbit, "position", \
	 null, second_pos + Vector2(-7,-7), travel_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
######

	green.visible = true
	orange.visible = true
	ribbit.visible = true
	orange.extctrl_facing_direction = orange.Direction.LEFTUP
	green.extctrl_facing_direction = green.Direction.DOWN
	ribbit.extctrl_facing_direction = ribbit.Direction.RIGHTDOWN
	green.clear_history()
	
	bell_player.play()
	$DoorAudio.set_stream(open_audio)
	match player_floor:
		Floor.BOTTOM:
			door_animator.play("open_top")
			opened_door = Floor.TOP
		Floor.TOP:
			door_animator.play("open_bottom")
			opened_door = Floor.BOTTOM
	yield(door_animator, "animation_finished")
	bottom_signal.frame = 0
	top_signal.frame = 0
	orange.controlled_by = original_orange_controller
	ribbit.controlled_by = original_ribbit_controller
	green.controlled_by = green.PERSON

	player_in_elevator = false
	door_trigger_bottom.set_deferred("disabled", false)
	door_trigger_top.set_deferred("disabled", false)
	$Timer.start()

func _on_Timer_timeout():
	trigger_bottom.set_deferred("disabled", false)
	trigger_top.set_deferred("disabled", false)


func _on_DoorAreaBottom_body_entered(body):
	if body == global.get_player() and (opened_door != Floor.BOTTOM):
		$DoorAudio.set_stream(open_audio)
		door_animator.play("open_bottom")
		opened_door = Floor.BOTTOM
func _on_DoorAreaTop_body_entered(body):
	if body == global.get_player() and (opened_door != Floor.TOP):
		$DoorAudio.set_stream(open_audio)
		door_animator.play("open_top")
		opened_door = Floor.TOP

func _on_DoorAreaTop_body_exited(body):
	if body == global.get_player() and (player_in_elevator == false):
		$DoorAudio.set_stream(close_audio)
		door_animator.play_backwards("open_top")
		opened_door = Floor.NONE

func _on_DoorAreaBottom_body_exited(body):
	if body == global.get_player() and (player_in_elevator == false):
		$DoorAudio.set_stream(close_audio)
		door_animator.play_backwards("open_bottom")
		opened_door = Floor.NONE

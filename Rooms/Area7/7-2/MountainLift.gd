extends Sprite

onready var trigger_area = $TriggerArea
onready var exit_col = $KinematicBody2D/ExitCollision
onready var animator = $AnimationPlayer
onready var bell = $Bell
onready var stop_sound = $StartStop
onready var level_collision = get_tree().get_current_scene().get_node_or_null("Tilemaps/Collision")
onready var above_lift_tiles = get_tree().get_current_scene().get_node_or_null("Tilemaps/7-2/AboveElevator")

onready var green = global.get_player(1)
onready var orange = global.get_player(2)
onready var ribbit = global.get_player(3)

#onready var player_sort = get_tree().get_current_scene().get_node("YSort")

var green_entered = false
var orange_entered = false

var moving = false

var previous_pos = position
var velocity


func _ready():
	trigger_area.connect("body_entered", self, "_on_body_entered")

func _process(delta):
	if moving:
		velocity = position - previous_pos
#		player_sort.position = player_sort.position + velocity
		green.position = green.position + velocity
		orange.position = orange.position + velocity
		ribbit.position = ribbit.position + velocity
		previous_pos = position

func _on_body_entered(body):
	if body == green:
		
		# Preparing
		if level_collision:
			level_collision.set_collision_mask(0)
		if above_lift_tiles:
			above_lift_tiles.z_index = 1
		trigger_area.set_deferred("monitoring", false) 
		exit_col.set_deferred("disabled", false)
		if PlayerStats.player_count > 1:
			$Tween.interpolate_property(orange, "position", null, green.position,
			0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
			$Tween.start()
			yield($Tween, "tween_all_completed")
		animator.play("shift_mode")
		bell.play()
		stop_sound.play()
		yield(get_tree().create_timer(1), "timeout")
		
		# Moving 
		var destination = $DestinationPos.position - position
		$Tween.interpolate_property(self, "position", null, destination,
		8, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		$Tween.start()
		moving = true
		yield($Tween, "tween_all_completed")
		
		# Cleaning up
		moving = false
		animator.play_backwards("shift_mode")
		yield(get_tree().create_timer(0.2), "timeout")
		stop_sound.play()
		yield(animator, "animation_finished")
		exit_col.set_deferred("disabled", true)
		if level_collision:
			level_collision.set_collision_mask(1)
		if above_lift_tiles:
			above_lift_tiles.z_index = 0



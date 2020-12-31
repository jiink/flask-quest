extends Node

onready var player = get_tree().get_nodes_in_group("Player")[0]
func start_event():
	player = global.get_player()
	$Tween.interpolate_property(player, "position",
			null, Vector2(209, 68),
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	player.direction = player.Direction.UP
	yield(get_tree().create_timer(0.5), "timeout")
	$AnimationPlayer.play("main")

func open_lab_door():
	get_parent().lab_door_open = true
	get_parent().update_lab_door()

func _on_AnimationPlayer_animation_finished(anim_name):
	print("%sBAAA"%player.frozen)

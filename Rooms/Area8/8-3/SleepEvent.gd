extends Node2D

onready var animator = $AnimationPlayer
var activated = false

func _ready():
	$EventActivation.connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body):
	if body == global.get_player(1) and (not activated):
		global.freeze_all_players()
		activated = true
		animator.play("door_close")
		yield(animator, "animation_finished")
		DiagHelper.start_talk(self, "Initial")
		
func warm_car():
	animator.play("warm")
	yield(get_tree().create_timer(2), "timeout")
	DiagHelper.start_talk(self, "Warm")

func next_scene():
	animator.play("faint")
	yield(animator, "animation_finished")
	global.start_scene_switch("res://Rooms/Area9/9-1/9-1.tscn", Vector2(0,0))
	global.swap_scenes()

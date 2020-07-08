extends Node2D

var players_done_eating = 0
var complete = false

func _ready():
	$ReferenceBackground.queue_free()
	$GreenHolding.connect("finished_eating", self, "_on_finished_eating")
	$OrangeHolding.connect("finished_eating", self, "_on_finished_eating")
	$AnimationPlayer.play("main")

func _on_finished_eating():
	players_done_eating += 1
	if players_done_eating >= 2:
		complete = true
		close()

func close():
	get_tree().get_current_scene().get_node("BattleScene/Win").start()
	yield(get_tree().create_timer(5), "timeout")
	queue_free()

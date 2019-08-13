extends Node2D



func _ready():
	visible = false
	global.connect("battle_won", self, "on_battle_won")

func start_brainjar_battle():
	global.start_battle(["BrainJar"])
#	visible = false
	
func jump_to_them():
	$JumpAnimation.play("default")

func on_battle_won():
	visible = false
	get_tree().get_current_scene().on_brainjar_defeat()
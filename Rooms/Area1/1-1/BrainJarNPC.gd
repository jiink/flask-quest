extends Node2D

func _ready():
	visible = false

func start_brainjar_battle():
	global.start_battle(["BrainJar"])
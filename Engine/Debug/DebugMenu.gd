extends Panel

onready var spinbox = $VBoxContainer/HBoxContainer/SpinBox

onready var game_saver = $GameSaver

func _ready():
	$VBoxContainer/SaveButton.connect("button_down", self, "save_pressed")
	$VBoxContainer/LoadButton.connect("button_down", self, "load_pressed")

func save_pressed():
	game_saver.save(spinbox.value)
	
func load_pressed():
	game_saver.load(spinbox.value)
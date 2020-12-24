extends Area2D

onready var pghost = get_tree().get_current_scene().get_node("PlayerGhost")

func _ready():
	connect("body_entered", self, "_on_body_entered")

# Load your save when you try to leave the deathspanse
func _on_body_entered(body):
	if body == pghost:
		GameSaver.load_from_save_station()

extends "res://Rooms/TemplateRoom.gd"

func _ready():
	$ReceptionistTrigger.connect("body_entered", self, "_receptionist_triggered")

func _receptionist_triggered(body):
	if body in global.get_players():
		$YSort/Desk/DouglistReceptionist.set_actively_staring(true)

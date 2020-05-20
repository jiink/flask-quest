extends Node2D

func _ready():
	$ChargingArea.connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body):
	if body.name.find("Battery") != -1:
		if not body.charged:
			body.set_charged(true)


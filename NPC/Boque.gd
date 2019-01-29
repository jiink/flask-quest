extends Node2D

#signal talk(txt, choices, txtSpeed)
signal talk(obj)


func _ready():
	connect("talk", get_owner().get_node("HUD/Diag"), "start_talk")
	
func interact():
	#emit_signal("talk", "Lorem ipsum dolor. Sit amet, consectetur, adipiscing elit.", ["Okay", "Nokay"], 0.03)
	emit_signal("talk", self)
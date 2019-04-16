extends ColorRect

var max_hp
onready var stats = get_node("/root/PlayerStats")

func _ready():
	
	if name == "GreenHPBar":
		max_hp = stats.green_max_hp
	elif name == "OrangeHPBar":
		max_hp = stats.orange_max_hp


func update_bar():
	
	var hp
	if name == "GreenHPBar":
		hp = stats.green_hp
	elif name == "OrangeHPBar":
		hp = stats.orange_hp
		 
	rect_scale.y = hp / max_hp
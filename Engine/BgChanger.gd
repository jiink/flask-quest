extends Area2D

export(Texture) var new_battle_bg

func _ready():
	self.connect("body_entered", self, "on_body_entered")
	

func on_body_entered(body):
	if body == global.get_player():
		global.battle_bg = new_battle_bg

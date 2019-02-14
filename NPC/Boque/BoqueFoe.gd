extends "res://Engine/Battle/BaseFoe.gd"



func _ready():
	max_hp = 20
	hp = max_hp
	update_hp_label()
	
	$AnimationPlayer.play("Idle")
	$AnimationPlayer.seek(rand_range(0,0.9))
	
func _process(delta):
	pass
	#position.x += rand_range(-1,1)
	#position.y += rand_range(-1,1)
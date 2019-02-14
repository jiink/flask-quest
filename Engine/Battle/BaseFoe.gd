extends Node2D

signal foe_died

var max_hp
var hp

var damage = 15

func _ready():
	max_hp = 100
	hp = max_hp
	
	connect("foe_died", get_node("/root/BattleScene"), "foe_died")
	update_hp_label()
	
func get_hurt(damage):
	hp -= damage
	update_hp_label()
	
	if hp <= 0:
		die()
		
func die():
	emit_signal("foe_died")
	queue_free()

func update_hp_label():
	$HPLabel.text = str(str(hp), " / ", str(max_hp))
extends Node2D

signal foe_died

export(Array, String) var lines
export(float) var talk_chance = 100.0

export(int) var max_hp = 100
var hp

export(Array, String) var types

export(int) var dollar_reward = 6

var damage = 15

export(AudioStream) var custom_music

export(String) var attack_order
var attack_order_index = 0

func _ready():
	hp = max_hp
	connect("foe_died", get_node("../.."), "foe_died")
	update_hp_label()
	
func get_hurt(damage):
	$BaseAnimationPlayer.play("hurt")
	hp -= damage
	update_hp_label()
	
	var damage_number = load("res://Engine/Battle/DamageNumber.tscn").instance()
#	damage_number.set_position(position)
	damage_number.num = damage
	add_child(damage_number)
	
	if hp <= 0:
		die()
		
func die():
	emit_signal("foe_died")
	queue_free()

func say_line():
	if randf() * 100 < talk_chance:
		if lines.size() > 0:
			var line_to_say = lines[randi() % lines.size()]
			var sbub = load("res://Engine/Battle/SpeechBubble.tscn").instance()
			print('%s: "%s"' % [name, line_to_say])
			sbub.text = line_to_say
			sbub.rect_position += Vector2(randi() % 32 - 16, -64 + randi() % 16 - 8)
			add_child(sbub)
		

func update_hp_label():
	$HPLabel.text = str(str(hp), " / ", str(max_hp))
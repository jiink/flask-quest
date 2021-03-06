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
var attacks_completed = 0

export(bool) var is_boss = false

onready var battle = get_node("../..")

func _ready():
	hp = max_hp
	connect("foe_died", battle, "foe_died")
	battle.connect("foe_attack_completed", self, "attack_completed")
	if Debug.debug_mode:
		update_hp_label()
	else:
		# hide that label
		var h = get_node_or_null("HPLabel")
		if h:
			h.visible = false
	
func get_hurt(base_damage):
	$BaseAnimationPlayer.play("hurt")
	hp -= base_damage
	update_hp_label()
	
	# only do damage numbers in debug mode
	if Debug.debug_mode:
		var damage_number = load("res://Engine/Battle/DamageNumber.tscn").instance()
	#	damage_number.set_position(position)
		damage_number.num = base_damage
		get_parent().add_child(damage_number)
		damage_number.position = self.position
	
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
		
# only shown in debug mode
func update_hp_label():
	if Debug.debug_mode:
		$HPLabel.text = str(str(hp), " / ", str(max_hp))

func attack_completed():
#	print("i, %s, completed my %sth attack" % [name, attacks_completed])
	pass

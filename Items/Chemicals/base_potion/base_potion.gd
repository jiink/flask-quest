extends Node2D

export(int) var damage = 10
export(int) var damage_randomness = 2
export(Array, String) var effects = []
export(Array, float) var effect_chance_ratios = []

var effect_chances = []
var effect_names = []
var effect_levels = []
var has_effects = true

onready var battle = get_node("../../..")

export(float) var fill_target = 50.0
export(float) var fill_speed = 0.8

func _ready():
	
	if effects.size() != effect_chance_ratios.size():
		print("error: effects and effect_chance_ratios must be the same size")
	
	
	elif effect_chance_ratios.size() > 0:
		if effect_chance_ratios.size() != 1:
			var ratiosum = 0
			for rationum in effect_chance_ratios:
				ratiosum += rationum
			for rationum in effect_chance_ratios:
				effect_chances.append(float(rationum) / ratiosum)
		else:
			effect_chances.append(float(effect_chance_ratios[0]) / 100.0)
		print(effect_chances)
		for fx in effects:
			# "fire2" --> fx name: "fire", fx lvl: "2"
			var nam = fx.rstrip("0123456789")
			var lvl = fx.replace(nam, "")
			lvl = 1 if lvl == "" else lvl
			effect_names.append(nam)
			effect_levels.append(int(lvl))
	elif effects.size() <= 0:
		has_effects = false

func do_thing(foes, selected_foe, effectiveness):
	var d = damage + (damage_randomness * 2 - damage_randomness) * effectiveness
	battle.hurt(foes[selected_foe], d)
	if has_effects:
		battle.inflict_effect(foes[selected_foe], get_effect())

func get_effect():
	var selected_effect = {}
	var e
	for i in range(effect_chances.size()):
		if randf() <= effect_chances[i]:
			e = i
			break
	selected_effect = {effect_names[e] : effect_levels[e]}
	return selected_effect
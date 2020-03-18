extends Node2D

export(float) var perfect_multiplier = 2.3
export(int) var fill_tolerance = 25
export(int) var fill_target = 50
export(float) var fill_speed = 0.8

export(int) var effectiveness = 100 # damage for offensive ones
export(int) var min_effectiveness = 23

export(Array, String) var effects = []
export(Array, float) var effect_chance_ratios = []

var effect_chances = []
var effect_names = []
var effect_levels = []
var has_effects = true

onready var battle = get_node("../../..")

enum {
	OFFENSE,
	DEFENSE
}

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

# extends need a fire() function

func get_effect():
	var selected_effect = {}
	
	var total_sum = 0
	for i in range(effect_chance_ratios.size()):
		total_sum += effect_chance_ratios[i]
	
	var rand = randf() * total_sum
	
	var cum_sum = 0
	var chosen_index = -1
	for i in range(effect_chance_ratios.size()):
		cum_sum += effect_chance_ratios[i]
		if rand < cum_sum:
			chosen_index = i
			break
	
	print("getting effect: chosen_index is %s" % chosen_index)
	selected_effect = {effect_names[chosen_index] : effect_levels[chosen_index]}
	return selected_effect

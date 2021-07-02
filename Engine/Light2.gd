extends Node2D

export var color = Color(1, 0.95, 0.9)
export var target_radius = 64
var radius = 64
export (float, 0.0, 2.0, 0.05) var target_strength = 1.0
var strength = 1.0
export(float) var rad_flicker = 0.0
export(float) var brightness_flicker = 0.0
var random_multiplier = 0.5
export(float) var lerp_weight = 0.3

func _ready():
	radius = target_radius
	strength = target_strength

func _tick():
	randomize()
#	random_multiplier = randf()
	random_multiplier = lerp(random_multiplier, randf() - 0.5, lerp_weight)
	
	strength = target_strength + random_multiplier * brightness_flicker
	radius = target_radius + random_multiplier * rad_flicker

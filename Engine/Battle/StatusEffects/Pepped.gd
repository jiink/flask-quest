extends "res://Engine/Battle/StatusEffects/Mundane.gd"

var effectiveness_multiplier
const LEVEL_TO_EFFECTIVENESS_FACTOR = 0.7

func _ready():
	duration = 2
	effectiveness_multiplier = level * LEVEL_TO_EFFECTIVENESS_FACTOR + 0.5

# called by PouringEvent when the output_effectiveness is calculated
func modify_pour_effectiveness(effectiveness_in):
	return effectiveness_in * effectiveness_multiplier

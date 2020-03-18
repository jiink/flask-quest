extends "res://Items/Chemicals/base_chemical/base_chemical.gd"

var category = OFFENSE

func fire(foes, selected_foe, output_damage):
	battle.hurt(foes[selected_foe], output_damage)
	if has_effects:
		battle.inflict_effect(foes[selected_foe], get_effect())

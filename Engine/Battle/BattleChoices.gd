extends Sprite

onready var battle = get_owner()

func _process(delta):
	if battle.selected_battle_choice == "attack":
		if battle.battle_choice_confirmed:
			frame = 2
		else:
			frame = 1
	elif battle.selected_battle_choice == "item":
		if battle.battle_choice_confirmed:
			frame = 4
		else:
			frame = 3
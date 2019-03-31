extends Sprite

onready var battle = get_owner()
onready var chem_anim = get_node("AnimationPlayer")

func _ready():
	chem_anim.connect("animation_finished", self, "chem_anim_finish")
	
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
			
	if Input.is_action_just_pressed("a") and battle.selected_battle_choice == "attack":
			
		chem_anim.play("Popout")
		
	elif Input.is_action_just_pressed("b") and battle.selected_battle_choice == "attack":
		#chem_anim.current_animation_position == chem_anim.current_animation_length:
		
		
		chem_anim.play_backwards("Popout")

func chem_anim_finish(s):
	chem_anim.stop()
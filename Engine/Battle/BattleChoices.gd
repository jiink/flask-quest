extends Sprite

onready var battle = get_owner()
onready var chem_anim = get_node("AnimationPlayer")

var ready_for_inv = false

func _ready():
	chem_anim.connect("animation_finished", self, "chem_anim_finish")
	chem_anim.play_backwards("Popout")
	
func _process(delta):
	if battle.selected_battle_choice == "attack":
		if battle.battle_choice_confirmed:
			frame = 2
		else:
			frame = 1
	elif battle.selected_battle_choice == "item":
		if battle.battle_choice_confirmed:
			frame = 4
			ready_for_inv = true
		else:
			frame = 3
			ready_for_inv = false
		
		

func chem_anim_finish(s):
	chem_anim.stop()

func open_chems():
	print("opening")
	chem_anim.play("Popout")
	
func close_chems():
	print("closing")
	chem_anim.play_backwards("Popout")
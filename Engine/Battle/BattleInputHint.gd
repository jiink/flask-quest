extends Node2D

export(bool) var flashy = false
export(String) var action_hint = "right"
export(bool) var only_1p = false
export(String) var label = ""

func _ready():
	
	# add 2nd one if 2P
	if (not only_1p) and (PlayerStats.player_count > 1): 
		# Make 1st one green and to the left
		$KeyboardHint1/Highlight.set_frame_color(global.GREEN_COLOR)
		$KeyboardHint1.position.x = -13
		# Make 2nd one orange and to the right
		var keyboard_hint_2 = $KeyboardHint1.duplicate()
		keyboard_hint_2.get_node("Highlight").set_frame_color(global.ORANGE_COLOR)
		keyboard_hint_2.position.x = 13
		add_child(keyboard_hint_2)
		keyboard_hint_2.setup(flashy, action_hint + "2")
	
	$KeyboardHint1.setup(flashy, action_hint)
	$GamepadHint.setup(flashy, action_hint)
	
	$Label.text = label

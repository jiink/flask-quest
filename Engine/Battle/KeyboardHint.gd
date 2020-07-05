extends Sprite

func setup(var flashy, var action_hint):
	if flashy:
		$Highlight.visible = true
		$AnimationPlayer.play("flashing")
	else:
		$Highlight.visible = false
	
	# gets element of action, gets scancode, and turn that scancode into a readable string
	var key_string = "ERR"
	for i in range(InputMap.get_action_list(action_hint).size()):
		if InputMap.get_action_list(action_hint)[i].get("scancode"):
			key_string = OS.get_scancode_string(InputMap.get_action_list(action_hint)[i].scancode) 
	
	var key_icon_path = "res://Engine/InputIcons/"
	var keys_to_icons = {
		"Up" : "kb_arrow_up",
		"Down" : "kb_arrow_down",
		"Left" : "kb_arrow_left",
		"Right" : "kb_arrow_right",
		"Space" : "kb_space",
	}
	if keys_to_icons.has(key_string):
		$Icon.texture = load(key_icon_path + keys_to_icons[key_string] + ".png")
		$Label.text = "";
	else:
		$Label.text = key_string;
	

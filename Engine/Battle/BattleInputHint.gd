extends Sprite

export(bool) var flashy = false
export(String) var action_hint = "right"

func _ready():
	if flashy:
		$Highlight.visible = true
		$AnimationPlayer.play("flashing")
	else:
		$Highlight.visible = false
	
	# gets first element of action, gets scancode, and turn that scancode into a readable string
	var key_string = OS.get_scancode_string(InputMap.get_action_list(action_hint)[0].scancode)
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

func _process(delta):
	pass

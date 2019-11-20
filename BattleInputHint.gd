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
	$Label.text = OS.get_scancode_string(InputMap.get_action_list(action_hint)[0].scancode)

func _process(delta):
	pass
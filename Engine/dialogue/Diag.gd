extends Node2D

var new_text = ""
var text_index = -1
var text_time = 0.04
var selected_choice = 0
var select_graphic_offset = 0
var choices = []
var submit = null

# "`" for delay
var effectchars = "`"
var visible_new_text = ""

var target_tree = null
var target_piece = null

# use tres
var text_font = load("res://Engine/Fonts/apple_kid.tres")


func _ready():
	$TextBox/Timer.connect("timeout", self, "next_letter_time")
	#$TextBox.add_font_override("font", text_font)

func _process(delta):
	if visible:
		for l in effectchars:
			visible_new_text = new_text.replace(l, "")
		
	if visible and $Choices.visible and not choices.empty():
		if Input.is_action_just_pressed("down"):
			selected_choice = clamp(selected_choice + 1, 0, choices.size() - 1)
		elif Input.is_action_just_pressed("up"):
			selected_choice = clamp(selected_choice - 1, 0, choices.size() - 1)
		
		
		select_graphic_offset = selected_choice * 24
		$Choices/Selection.position.y = select_graphic_offset
		
		if Input.is_action_just_pressed("a") and $TextBox.text == visible_new_text:
			for D in target_piece.get_children():
				if D.key == choices[selected_choice]:
					update_boxes(D)
					break
	else:
		if Input.is_action_just_pressed("a") and $TextBox.text == visible_new_text:
			if target_piece.get_children():
				update_boxes(target_piece.get_child(0))
			else:
				close()
			

func start_talk(obj):
	print("start_talk exec'd")
	# go to first diagpiece 
	target_tree = obj.get_node("DialogueTree/")
	obj = target_tree.get_node("DiagPiece/")
	open()
	update_boxes(obj)
	
	
func update_boxes(new_target):
	target_piece = new_target
	
	# reset text and choices 
	$TextBox.text = ""
	text_index = -1
	choices = []
	
	new_text = target_piece.message
	
	# set delays
	if target_piece.text_delay != null:
		print("bad")
		text_time = target_piece.text_delay
	else:
		text_time = target_tree.default_text_delay
	
	# set font
	if target_tree.default_font != null:
		text_font = target_tree.default_font
		$TextBox.add_font_override("font", text_font)
	
	#get choices
	for D in target_piece.get_children():
		if D.key != "Null":
			choices.append(D.key)
		
	if not choices.empty():
		$Choices/Choice1.text = choices[0]
		$Choices/Choice2.text = choices[1]
	else:
		$Choices/Choice1.text = ""
		$Choices/Choice2.text = ""
		$Choices.set_visible(false)
	
	$TextBox/Timer.wait_time = 0.03
		
	$TextBox/Timer.start()
		
	# face
	var expressions = ["neutral", "openmouth", "sidemouth", "happy", "cute", "sad", "suspicious", "crying",
				 "cryingloud", "grin", "bigsurprise", "biggersurprise", "angry", "misc", "surprise", "stare",
				"smug"]
	
	var face_index
	
	if target_piece.face != null or target_piece.face != "":
		if target_piece.face.is_valid_integer():
			face_index = int(target_piece.face)
		else:
			face_index = expressions.find(target_piece.face)
		
	$Face.texture = target_tree.face_texture
	$Face.frame = face_index
	
	
func next_letter_time():
	if text_index < new_text.length() - 1:
		if ".?!:,;`".find(new_text[text_index + 1]) != -1:
			$TextBox/Timer.wait_time = text_time + 0.1
		else:
			$TextBox/Timer.wait_time = text_time
		text_index += 1
		if new_text[text_index] != "`":
			$TextBox.text += new_text[text_index]
	else:
		text_index = -1
		
		$TextBox/Timer.stop()
		$Choices.set_visible(not choices.empty())
		#close()
		
func open():
	set_visible(true)
	$Choices.set_visible(false)
	
func close():
	set_visible(false)

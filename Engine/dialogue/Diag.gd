extends Node2D

var new_text = ""
var text_index = -1
var text_time = 0.04
var voice_sound = null
var voice_variation = 0.3
var selected_choice = 0
var select_graphic_offset = 0
var choices = []
var submit = null
var face_index = 0
var has_face = false

var stored_function = ""
var stored_function_args = []


# "`" for delay
var effectchars = "`"
var visible_new_text = ""

var target_tree = null
var target_piece = null
var first = true

# use tres
var text_font = load("res://Engine/Fonts/FontQuestSmall.tres")

onready var audio = $AudioStreamPlayer

func _ready():
	$TextBox/Timer.connect("timeout", self, "next_letter_time")
	#$TextBox.add_font_override("font", text_font)

func _process(delta):
	if visible:
		if $Choices.visible and not choices.empty():
			if Input.is_action_just_pressed("down"):
				selected_choice = clamp(selected_choice + 1, 0, choices.size() - 1)
			elif Input.is_action_just_pressed("up"):
				selected_choice = clamp(selected_choice - 1, 0, choices.size() - 1)
			
			
			select_graphic_offset = selected_choice * 30
			$Choices/Selection.position.y = select_graphic_offset
			
			if Input.is_action_just_pressed("a") and $TextBox.text == visible_new_text:
				for D in target_piece.get_children():
					if D.key == choices[selected_choice]:
						run_func()
						update_boxes(D)
						break
		else:
			if Input.is_action_just_pressed("a"):
				if $TextBox.text == visible_new_text:
					if target_piece.get_children():
						run_func()
						update_boxes(target_piece.get_child(0))
					else:
						run_func()
						close()
					
				elif $TextBox.text.length() > 2 and target_piece.skippable:
					$TextBox.text = visible_new_text
					text_index = $TextBox.text.length() - 1
					

func start_talk(obj, starting_branch):
	print("start_talk exec'd")
	if starting_branch == null:
		starting_branch = "DiagPiece"
	# go to first diagpiece 
	target_tree = obj.get_node("DialogueTree/")
	obj = target_tree.get_node("%s/" % starting_branch)
	open()
	update_boxes(obj)
	
	
func update_boxes(new_target):
	target_piece = new_target
	
	# reset text and choices 
	$TextBox.text = ""
	text_index = -1
	choices = []
	
	new_text = target_piece.message
	
	for l in effectchars:
		visible_new_text = new_text.replace(l, "")
		
	# set delays
	if target_piece.text_delay != null and target_piece.text_delay != 0:
		text_time = target_piece.text_delay
	else:
		text_time = target_tree.default_text_delay
	
	# set sound
	if target_tree.voice_sound != null:
		voice_sound = target_tree.voice_sound
		audio.set_stream(voice_sound)
	if target_tree.voice_variation != null:
		voice_variation = clamp(target_tree.voice_variation, 0.0, 0.9)
	
	# set font
	if target_tree.default_font != null:
		text_font = target_tree.default_font
		$TextBox.add_font_override("font", text_font)
	#get choices
	for D in target_piece.get_children():
		if D.key != "Null":
			choices.append(D.key)
		
	if not choices.empty():
		selected_choice = 0
		$Choices/Choice1.text = choices[0]
		$Choices/Choice2.text = choices[1]
	else:
		$Choices/Choice1.text = ""
		$Choices/Choice2.text = ""
		$Choices.set_visible(false)
	
	#$TextBox/Timer.wait_time = 0.03
		
	$TextBox/Timer.start(text_time)
		
	# face
	has_face = !(target_tree.face_texture == null or target_piece.no_face)
	
	var expressions = ["neutral", "openmouth", "sidemouth", "happy", "cute", "sad", "suspicious", "crying",
				 "cryingloud", "grin", "bigsurprise", "biggersurprise", "angry", "misc", "surprise", "stare",
				"smug"]
	
	if has_face:
	#	if target_tree.face_texture != null:
	#		$Face.texture = target_tree.face_texture
	#	else:
			
		
	#
	#	if target_piece.expression != null or target_piece.expression != "":
	#		if target_piece.expression.is_valid_integer():
	#			face_index = int(target_piece.expression)
	#		else:
	#			face_index = expressions.find(target_piece.expression)
		if first:
			if target_tree.face_texture != null:
				$Face.texture = target_tree.face_texture
				
		if target_piece.face_texture != null:
			$Face.texture = target_piece.face_texture
	
		if target_piece.expression != "(none)":
			face_index = expressions.find(target_piece.expression)
		
		$Face.frame = face_index
		$Face.visible = true
		$TextBox.margin_left = 55
		$FaceBorder.visible = true
	else:
		# we just want text, and no face displayed
		$Face.visible = false
		$TextBox.margin_left = 12
		$FaceBorder.visible = false
	
	# function
	
	if target_piece.function != "":
		stored_function = target_piece.function
		stored_function_args = target_piece.args
	
func next_letter_time():
	if text_index < new_text.length() - 1:
		if ".?!:,;`".find(new_text[text_index + 1]) != -1:
			$TextBox/Timer.start(text_time + 0.15)
		else:
			$TextBox/Timer.start(text_time)
		text_index += 1
		if new_text[text_index] != "`":
			$TextBox.text += new_text[text_index]
	else:
		text_index = -1
		
		$TextBox/Timer.stop()
		$Choices.set_visible(not choices.empty())
		#close()
		
	play_sound()

func run_func():
	print("stored func: %s" % stored_function)
					
	if stored_function != "":
		if target_tree.get_parent().has_method(stored_function):
			# help me
			if stored_function_args != null:
				match stored_function_args.size():
					0:
						target_tree.get_parent().call(stored_function)
					1:
						target_tree.get_parent().call(stored_function, stored_function_args[0])
					2:
						target_tree.get_parent().call(stored_function, stored_function_args[0], stored_function_args[1])
					3:
						target_tree.get_parent().call(stored_function, stored_function_args[0], stored_function_args[1], stored_function_args[2])
					4:
						target_tree.get_parent().call(stored_function, stored_function_args[0], stored_function_args[1], stored_function_args[2], stored_function_args[3])
					5:
						target_tree.get_parent().call(stored_function, stored_function_args[0], stored_function_args[1], stored_function_args[2], stored_function_args[3], stored_function_args[4])
					_:
						pass
			else:
				target_tree.get_parent().call(stored_function)
		else:
			print("diag function not found")
		
		stored_function = ""
		stored_function_args = []

func play_sound():
	audio.pitch_scale = randf() * voice_variation + (1.0 - voice_variation*0.5)
	audio.play()

func open():
	set_visible(true)
	$Choices.set_visible(false)
	get_tree().get_nodes_in_group("Player")[0].frozen = true
	
func close():
	set_visible(false)
	get_tree().get_nodes_in_group("Player")[0].frozen = false

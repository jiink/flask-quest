extends Node2D

var new_text = ""
var text_index = -1
var text_time = 0.04
var default_text_time = 0.04
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

var active = false

# use tres
var default_text_font = load("res://Engine/Fonts/FontQuestSmall.tres")
var text_font = default_text_font

onready var default_face = $Face.texture

enum { CHAR_FACE, CHAR_VOICE, CHAR_VOICE_VARIATION, CHAR_NAME }
var characters = {
	"(none)": [null, "res://NPC/default_voice2.wav", 0.0, ""],
	"orange" : ["res://Player/orange_sprites/orangeFaces.png", "res://Player/orange_sprites/orange_speech.wav", 0.3, "Orange"],
	"stercus" : ["res://NPC/Stercus/stercusFaces.png", "res://NPC/Stercus/stercus_voice.wav", 0.0, "Stercus"],
	"green": ["res://Player/sprites/greenSheet.png", "res://NPC/default_voice2.wav", 0.0, "Green"],
	"ribbit": ["res://Player/ribbit_sprites/ribbitFaces.png", "res://Player/ribbit_sprites/ribbit_speech.wav", 0.3, "Ribbit"],
	}

onready var audio = $AudioStreamPlayer

func _ready():
	$TextBox/Timer.connect("timeout", self, "next_letter_time")
	#$TextBox.add_font_override("font", text_font)
				

func _input(event):
	if active:
		if $Choices.visible and not choices.empty():
			if event.is_action_pressed("down"):
				selected_choice = clamp(selected_choice + 1, 0, choices.size() - 1)
			elif event.is_action_pressed("up"):
				selected_choice = clamp(selected_choice - 1, 0, choices.size() - 1)
			
			
			select_graphic_offset = selected_choice * 30
			$Choices/Selection.position.y = select_graphic_offset
			
			if event.is_action_pressed("confirm") and $TextBox.text == visible_new_text:
				for D in target_piece.get_children():
					if D.key == choices[selected_choice]:
						run_func()
						update_boxes(D)
						break
		else:
			if event.is_action_pressed("confirm") or target_piece.interrupt:
				if $TextBox.text == visible_new_text:
					if target_piece.get_children():
						run_func()
						update_boxes(target_piece.get_child(0))
					else:
						run_func()
						close()
					
				elif $TextBox.text.length() > 2 and (target_piece.skippable or Debug.debug_mode):
					if not target_piece.interrupt:
						$TextBox.text = visible_new_text
						text_index = new_text.length() - 1
		get_tree().set_input_as_handled()



func start_talk(obj, starting_branch):
	# set the font back to normal on a new tree
	text_font = default_text_font
	$TextBox.add_font_override("font", text_font)
	# put face back at the default
	$Face.texture = default_face
	face_index = 0 # neutral

	# print("start_talk exec'd")
	if starting_branch == null:
		starting_branch = "DiagPiece"
	# go to first diagpiece 
	target_tree = obj.get_node("DialogueTree/")
	if target_tree == null:
		print("dialogue failed to start, tree nonexistant!")
		return
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
	
	# set the values from the character dict
	var chosen_character = characters[target_piece.character]
	if chosen_character[CHAR_FACE] != null: $Face.texture = load(chosen_character[CHAR_FACE])
	voice_sound = load(chosen_character[CHAR_VOICE])
	voice_variation = chosen_character[CHAR_VOICE_VARIATION]
	
	# set delays
	if (target_piece.text_delay != null) and (target_piece.text_delay != 0):
		text_time = target_piece.text_delay
	else:
		text_time = default_text_time
	
	# set sound
	if target_piece.voice_sound != null:
		voice_sound = target_piece.voice_sound
	
	if target_piece.voice_variation >= 0.0:
		voice_variation = target_piece.voice_variation
		voice_variation = clamp(voice_variation, 0.0, 0.9)
	
	audio.set_stream(voice_sound)
	
	# set font
	if target_piece.font != null:
		text_font = target_piece.font
		$TextBox.add_font_override("font", text_font)
		
	# get choices
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
		
	$TextBox/Timer.start(text_time)
		
	# face
	
	has_face = true
	if (target_piece.character == "(none)"):
		has_face = false
	if (target_piece.face_texture != null):
		has_face = true
	if $Face.texture != null:
		has_face = true
	if (target_piece.no_face):
		has_face = false

	var expressions = ["neutral", "open_mouth", "side_mouth", "smile", "kawaii", "sad",
		"smug", "cry_tear", "cry_mourn", "grin", "big_eyed", "big_eyed2", "angry",
		"unique", "dot_eyes", "closeup", "smug2", "cry_recover", "cry_sob", "frown",
		"drunk", "yell", "nervous", "yell_outburst", "confused", "blush"]
	
	if has_face:

		if target_piece.face_texture != null:
			$Face.texture = target_piece.face_texture
		
		var one_expression = false # for 32x32, one face textures (usually for minor npcs)
		print($Face.texture.get_size())
		if $Face.texture.get_size() == Vector2(32, 32):
			one_expression = true

		if target_piece.expression != "(none)":
			face_index = expressions.find(target_piece.expression)
		
		if not one_expression:
			$Face.vframes = 8
			$Face.hframes = 8
			$Face.frame = face_index
		else:
			$Face.vframes = 1
			$Face.hframes = 1
			$Face.frame = 0

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
	if not active: return # i don't want to talk about it
	if text_index < new_text.length() - 1:
		if ".?!:,;`".find(new_text[text_index + 1]) != -1:
			$TextBox/Timer.start(text_time + 0.15)
		else:
			$TextBox/Timer.start(text_time)
		text_index += 1
		if new_text[text_index] != "`":
			$TextBox.text += new_text[text_index]
		
		if not $DialogueBoxSprite/AnimationPlayer.is_playing():
			$DialogueBoxSprite/AnimationPlayer.play("busy")
	else:
		text_index = -1
		
		$TextBox/Timer.stop()
		$Choices.set_visible(not choices.empty())
		$DialogueBoxSprite/AnimationPlayer.stop()
		$DialogueBoxSprite/Tween.interpolate_property($DialogueBoxSprite, "modulate", null, Color.white, 0.2)
		$DialogueBoxSprite/Tween.start()
		#close()
	
	var ascii_code = new_text[text_index].ord_at(0)
	# 0-9, A-Z, and a-z are spoken letters
	if (ascii_code >= 48 and ascii_code <= 57) or \
			(ascii_code >= 65 and ascii_code <= 90) or \
			(ascii_code >= 97 and ascii_code <= 122):
		play_sound()
	
	# for interrupt...
	if target_piece.interrupt and $TextBox.text == visible_new_text:
		if target_piece.get_children():
			run_func()
			update_boxes(target_piece.get_child(0))
		else:
			run_func()
			close()

func run_func():
					
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
	active = true
	$Choices.set_visible(false)
	global.get_player(1).set_frozen(true, true)
	
func close():
	set_visible(false)
	active = false
	if not target_piece.dont_unfreeze_player:
		global.get_player(1).set_frozen(false, true)

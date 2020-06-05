extends Node2D

enum {RESUME, PLAYERS, OPTION, QUIT}
var selected_option = RESUME
onready var hud = $".."

onready var open_sound = preload("res://SoundEffects/pause_menu_open.wav")
onready var close_sound = preload("res://SoundEffects/pause_menu_close.wav")

func _ready():
	$Tween.interpolate_property(self, "position:y", 0, -256, .15, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()

	if not Debug.debug_mode:
		$DebugButtons.queue_free()

func _process(delta):
	if visible:
		if Input.is_action_just_pressed("pause"):
			close()
		
		if Input.is_action_just_pressed("down"):
			selected_option += 1

		elif Input.is_action_just_pressed("up"):
			selected_option -= 1
			
			
		if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up"):
			selected_option = clamp(selected_option, 0, 3)
			$Selection/Tween.interpolate_property($Selection, "position:y", $Selection.position.y, 
				72 + selected_option * 18, .05, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
			$Selection/Tween.start()
		
		if Input.is_action_just_pressed("confirm"):
			match selected_option:
				RESUME:
					close()
				PLAYERS:
					if PlayerStats.player_count == 1:
						PlayerStats.set_player_num(2)
						$Label.text = $Label.text.replace("1", "2")
					elif PlayerStats.player_count == 2:
						PlayerStats.set_player_num(1)
						$Label.text = $Label.text.replace("2", "1")
					print(PlayerStats.player_count)
				OPTION:
					print("Let's pretend to open the options menu")
					close()
					
				QUIT:
					print("Wow, you have a life? Y/N")
					get_tree().quit()
		
			
	else:
		if Input.is_action_just_pressed("pause"):
			print("hud visidiblity: %s" % hud.get_visibility())
			if not hud.get_visibility():
				open()
			elif Debug.debug_mode:
				open()
				print("opening pause menu anyway because debug mode")

func open():
	visible = true
	if global.get_player() != null:
		global.get_player().set_frozen(true, true)
	
	$BackgroundShader.visible = true
	
	$AudioStreamPlayer.stream = open_sound
	$AudioStreamPlayer.play()
	
	$Tween.interpolate_property(self, "position:y", 256, 0, .15, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	
	get_tree().paused = true

func close():
	
	if global.get_player() != null:
		global.get_player().set_frozen(false, true)
	
	$AudioStreamPlayer.stream = close_sound
	$AudioStreamPlayer.play()
	
	
	$Tween.interpolate_property(self, "position:y", 0, -256, .15, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(.15), "timeout")
	visible = false
	
	get_tree().paused = false


func _on_NoclipButton_toggled(button_pressed):
	for i in range(PlayerStats.player_count):
			global.get_player(i + 1).collision_layer = 0 if button_pressed else 1

func _on_InvincibilityButton_toggled(button_pressed):
	global.get_player().invincible = button_pressed

func _on_MusicButton_toggled(button_pressed):
	if button_pressed:
		MusicManager.set_volume(0)
	else:
		MusicManager.set_volume(-80)

func _on_GiveButton_pressed():
	ItemManager.give_item($DebugButtons/GiveText.text)

func _on_SpawnOrangeButton_pressed():
	global.get_player(1).get_parent().add_child(load("res://Player/Orange.tscn").instance())
	print("Orange spawned from debug menu")

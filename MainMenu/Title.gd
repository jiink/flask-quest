extends "res://Rooms/TemplateRoom.gd"

enum {OPTIONS, PLAY, QUIT}
enum {MAIN, SAVES, QUITCONFIRM}

var selection = PLAY
var focus = MAIN
var save_selection = 1

var quit_messages = ["Are you sure you want to quit?", "Quitting detected, press Y to self-destruct...", "Wow, you have a life?", "Gotta plane to catch?", "Bye bye", "Haha, you accidentally pressed \"Quit!\"", "You can't lose if you quit!", "You can't win if you quit!", "Missed the play button again?", "Have a day."]

func _ready():
	pass

func _process(delta):
	if focus == MAIN:
		if Input.is_action_just_pressed("right"):
			selection += 1

		elif Input.is_action_just_pressed("left"):
			selection -= 1
			
			
		if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
			selection = clamp(selection, 0, 2)
			
			for c in $Buttons.get_children():
				c.get_children()[0].visible = false
			
			match selection:
				
				OPTIONS:
					$Buttons/options.get_children()[0].visible = true
					
				PLAY:
					$Buttons/play.get_children()[0].visible = true
					
					
				QUIT:
					$Buttons/quit.get_children()[0].visible = true
		
		if Input.is_action_just_pressed("confirm"):
			match selection:
				
				OPTIONS:
					print("Let's pretend to open the options menu")
					
					
				PLAY:
					focus = SAVES
					$SaveSelect.visible = true
					update_save_list_colors()
				QUIT:
					focus = QUITCONFIRM
					$QuitConfirmation/Label.text = ("%s\nY/N" % quit_messages[randi() % quit_messages.size()]).to_upper()
					$QuitConfirmation.visible = true
					
	elif focus == SAVES:
		if Input.is_action_just_pressed("down"):
			save_selection += 1
	
		elif Input.is_action_just_pressed("up"):
			save_selection -= 1

		elif Input.is_action_just_pressed("right"):
			GameSaver.new_save()
			
			
		if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up"):
			save_selection = clamp(save_selection, 1, 3)
			update_save_list_colors()
		
		elif Input.is_action_just_pressed("cancel"):
			$SaveSelect.visible = false
			focus = MAIN
		elif Input.is_action_just_pressed("confirm"):
			$"/root/GameSaver".load_from_save_station()#save_selection)
			
	elif focus == QUITCONFIRM:
		if Input.is_action_just_pressed("confirm") or Input.is_key_pressed(KEY_Y):
			get_tree().quit()
		elif Input.is_action_just_pressed("cancel") or Input.is_key_pressed(KEY_N):
			$QuitConfirmation.visible = false
			focus = MAIN
		
		
func update_save_list_colors():
	var list = $SaveSelect/VBoxContainer
	for c in list.get_children():
		c.add_color_override("font_color", Color(1,1,1))
	list.get_children()[save_selection - 1].add_color_override("font_color", Color("72D031"))

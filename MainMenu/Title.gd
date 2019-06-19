extends Node2D

enum {OPTIONS, PLAY, QUIT}
enum {MAIN, SAVES}

var selection = PLAY
var focus = MAIN
var save_selection = 1

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
		
		if Input.is_action_just_pressed("a"):
			match selection:
				
				OPTIONS:
					print("Let's pretend to open the options menu")
					
					
				PLAY:
					focus = SAVES
					$SaveSelect.visible = true
					update_save_list_colors()
				QUIT:
					print("Wow, you have a life? Y/N")
					get_tree().quit()
	elif focus == SAVES:
		if Input.is_action_just_pressed("down"):
			save_selection += 1
	
		elif Input.is_action_just_pressed("up"):
			save_selection -= 1
			
			
		if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up"):
			save_selection = clamp(save_selection, 1, 3)
			update_save_list_colors()
		
		elif Input.is_action_just_pressed("b"):
			$SaveSelect.visible = false
			focus = MAIN
		elif Input.is_action_just_pressed("a"):
			$"/root/GameSaver".load_from_save_station(save_selection)

func update_save_list_colors():
	var list = $SaveSelect/VBoxContainer
	for c in list.get_children():
		c.add_color_override("font_color", Color(1,1,1))
	list.get_children()[save_selection - 1].add_color_override("font_color", Color("72D031"))
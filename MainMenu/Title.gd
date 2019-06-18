extends Node2D

enum {OPTIONS, PLAY, QUIT}
var selection = PLAY

func _ready():
	pass

func _process(delta):
		
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
					pass
					
				QUIT:
					print("Wow, you have a life? Y/N")
					get_tree().quit()
		
extends Node2D

enum {RESUME, OPTION, QUIT}
var selected_option = RESUME
onready var hud = $".."
onready var player = get_tree().get_nodes_in_group("Player")[0]
func _ready():
	pass

func _process(delta):
	if visible:
		if Input.is_action_just_pressed("esc"):
			visible = false
			player.frozen = false
		
		if Input.is_action_just_pressed("down"):
			selected_option += 1

		elif Input.is_action_just_pressed("up"):
			selected_option -= 1
			
			
		if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up"):
			selected_option = clamp(selected_option, 0, 2)
			$Selection/Tween.interpolate_property($Selection, "position:y", $Selection.position.y, 
				82 + selected_option * 18, .1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
			$Selection/Tween.start()
			
			
	else:
		if Input.is_action_just_pressed("esc"):
			if not hud.get_visibility():
				visible = true
				player.frozen = true
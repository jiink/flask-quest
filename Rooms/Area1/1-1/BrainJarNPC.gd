extends Node2D



func _ready():
	visible = false
	global.connect("battle_won", self, "on_battle_won")

func start_brainjar_battle():
	global.start_battle(["BrainJar"])
	yield(get_tree().create_timer(7.0), "timeout")
	var cam = get_tree().get_current_scene().get_node("Camera")
	cam.zoom = Vector2(1.0, 1.0) # reset the zoom and offset for when it zoomed in
	cam.offset = Vector2(0, 0)
	cam.follow_player = true
#	visible = false
	
func jump_to_them():
	$JumpAnimation.play("default")

func on_battle_won():
	visible = false
	get_tree().get_current_scene().on_brainjar_defeat()

func zoom_in():
	var cam = get_tree().get_current_scene().get_node("Camera")
	cam.zoom = Vector2(0.1, 0.1)
	cam.follow_player = false
	cam.position = Vector2(304, 86)
	# var calculated_offset = Vector2($Sprite.position.x - cam.position.x, $Sprite.position.y - cam.position.y)
	# cam.offset = calculated_offset
	

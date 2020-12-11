extends Node2D


onready var animation_player = $AnimationPlayer


func _ready():
#	animation_player.connect("animation_finished", self, "on_animation_finished")
	DiagHelper.start_talk(self, "Ascent")
#func on_animation_finished():
#	$clouds_bg.visible = true
	for image in get_tree().get_nodes_in_group("MMSequence"):
		image.visible = false
	$clouds_bg.visible = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "InitialSequence":
		$clouds_bg.visible = true
		$clouds_bigpicture.visible = false
		$boat_front_far.visible = true
		DiagHelper.start_talk(self, "PreBinoc")
	if anim_name == "FlashBacks":
		boat_front_far_b()
		DiagHelper.start_talk(self, "PostFlashBacks")

func change_image(image, frame): # make everything but what you want to see invis
	for image in get_tree().get_nodes_in_group("MMSequence"):
		image.visible = false
	var selected_image = get_node(image)
	selected_image.visible = true
	selected_image.frame = frame
	
	
func boat_front_far_a():
	change_image("boat_front_far", 0)

func boat_guideside_view_a():
	change_image("boat_guideside_view", 0)
	
func mountains_view():
	change_image("mountains_view", 0)
	
func boat_guideside_view_b():
	change_image("boat_guideside_view", 1)
	
func boat_guideside_view_c():
	change_image("boat_guideside_view", 2)
	
func ribbit_green_orange_closeup():
	change_image("ribbit_green_orange_closeup", 0)
	
func sweaty_green():
	change_image("sweaty_green", 0)
	$FlashBacks.visible = true
	animation_player.play("FlashBacks")
	
	
func boat_front_far_b():
	change_image("boat_front_far", 1)
	
func orange_denied():
	change_image("orange_denied", 0)
	
func orange_green_closeup_a():
	change_image("orange_green_closeup", 0)
	
func binocular_view():
	for image in get_tree().get_nodes_in_group("MMSequence"):
		image.visible = false
	$BinocularView.visible = true
	
func orange_green_closeup_b():
	change_image("orange_green_closeup", 1)
	
func orange_green_closeup_c():
	change_image("orange_green_closeup", 2)
	
func orange_green_closeup_d():
	change_image("orange_green_closeup", 3)
	
func boat_front_far_c():
	change_image("boat_front_far", 2)
	

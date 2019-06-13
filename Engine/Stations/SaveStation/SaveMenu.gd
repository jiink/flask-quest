extends Node2D

var save_slot_positions = [177, 121, 65]
var save_slot_selection = 1

func _ready():
	get_tree().get_nodes_in_group("Player")[0].frozen = true
	
func _process(delta):
	if Input.is_action_just_pressed("down"):
		save_slot_selection += 1
	
	elif Input.is_action_just_pressed("up"):
		save_slot_selection -= 1
	
	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up"):
		save_slot_selection = clamp(save_slot_selection, 1, 3)
		#$save_slots.position.y = save_slot_positions[save_slot_selection - 1]
		
		$Buttons/AnimationPlayer.stop(true)
		$Buttons/AnimationPlayer.play("slot_switch")
		
		$save_slots/Tween.interpolate_property($save_slots, "position:y", $save_slots.position.y, 
		save_slot_positions[save_slot_selection - 1], .3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$save_slots/Tween.start()
	
	elif Input.is_action_just_pressed("a"):
		$"/root/GameSaver".save_from_save_station(save_slot_selection)
		print("SAVVED")
		close()
		
	
	elif Input.is_action_just_pressed("b"):
		close()

func close():
	get_tree().get_nodes_in_group("Player")[0].frozen = false
	queue_free()

func _on_LoadButton_pressed():
	$"/root/GameSaver".load_from_save_station(save_slot_selection)
	print("LOOOADED??")
	close()

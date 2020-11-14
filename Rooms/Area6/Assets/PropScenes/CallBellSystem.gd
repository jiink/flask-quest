extends YSort

onready var boat = $Boat
onready var tween = $Tween

export(bool) var talkative

onready var green = global.get_player(1)
onready var orange = global.get_player(2)
onready var ribbit = global.get_player(3)
onready var players_in_boat = get_node("Boat/PlayersInBoat")
onready var boat_oar = $Boat/poppyhart_boaters/BoatOar
	
# has the player not interacted with any other bells
# in the past few seconds?
var player_available = true
	
func move_boat(callbell_number):
	if player_available:
		for callbell_systems in get_tree().get_nodes_in_group("callbell_system"):
			callbell_systems.player_available = false
			
		var original_orange_controller = orange.controlled_by
		var first_pos
		var second_pos
		var player_new_pos
		match callbell_number:
			1:
				first_pos = $Pos1.position
				second_pos = $Pos2.position
				player_new_pos = $CallBell2.position + Vector2(-5, -5) 
			2:
				first_pos = $Pos2.position
				second_pos = $Pos1.position
				player_new_pos = $CallBell1.position + Vector2(-5, -5) 
	#	move the boat to pos1
		
		if boat.position != first_pos:
			tween.interpolate_property(boat, "position", \
			null, first_pos, 2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
			tween.start()
			boat_oar.playing = true
			yield(tween, "tween_all_completed")
			boat_oar.playing = false
		elif boat.position == first_pos:
			yield(get_tree().create_timer(0.4), "timeout")
		
		orange.controlled_by = orange.EXTERNAL
		green.controlled_by = green.EXTERNAL
		
	#	move the players onto the boat
		tween.interpolate_property(green, "position", \
		null, first_pos + position, 0.1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		tween.interpolate_property(orange, "position", \
		null, first_pos + position, 0.1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		tween.interpolate_property(ribbit, "position", \
		null, first_pos + position, 0.5, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		tween.start()
		yield(tween, "tween_all_completed")
		
		green.visible = false
		orange.visible = false
		ribbit.visible = false
		players_in_boat.visible = true
		
		var travel_time
		if talkative:
			travel_time = 20
			DiagHelper.start_talk(self)
		else:
			travel_time = 4
		
	#	move the boat to pos2
		tween.interpolate_property(boat, "position", \
		null, second_pos, travel_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.interpolate_property(green, "position", \
		null, second_pos + position, travel_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.interpolate_property(orange, "position", \
		null, second_pos + position, travel_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
		boat_oar.playing = true
		yield(tween, "tween_all_completed")
		boat_oar.playing = false
		
	#	move players back onto land
		green.visible = true
		orange.visible = true
		ribbit.visible = true
		players_in_boat.visible = false
		
		tween.interpolate_property(green, "position", \
		null, player_new_pos + position, 0.1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		tween.interpolate_property(orange, "position", \
		null, player_new_pos + position, 0.1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		tween.interpolate_property(ribbit, "position", \
		null, $CallBell1.position + Vector2(-5, -5)+ position, 0.1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		tween.start()
		yield(tween, "tween_all_completed")
	
		green.clear_history()
		orange.controlled_by = original_orange_controller
		green.controlled_by = green.PERSON
		
		for callbell_systems in get_tree().get_nodes_in_group("callbell_system"):
			callbell_systems.player_available = true

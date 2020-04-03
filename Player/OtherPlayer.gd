extends "res://Player/Player.gd"

var follow_distance = 5

enum {
	HUMAN,
	BOT,
	EXTERNAL
}

export(int, "HUMAN", "BOT", "EXTERNAL") var controlled_by = HUMAN

onready var leader = get_node("../Player")

func _ready():
	extended = true
	
	# >1st player's input actions have their number after the name
	if player_number > 1:
		var player_number_s = str(player_number)
		player_up += player_number_s
		player_down += player_number_s
		player_left += player_number_s
		player_right += player_number_s
		player_confirm += player_number_s
		player_cancel += player_number_s
		player_action += player_number_s
	
	set_process(false)
	TickManager.set_tick(self, false)
	yield(get_tree().create_timer(0.2), "timeout")
	set_process(true)
	TickManager.set_tick(self, true)

func _process(delta):
	

	match controlled_by:
		HUMAN:
			previous_position = position
			#if not get_owner().get_node("HUD/Diag").visible:
			if not frozen:
				get_inputs()
			else:
				# stop player when diag box is up.
				motion = Vector2(0,0)
		#	motion = motion.normalized()
			move_and_animate()
			
			
		BOT:
			pass
#			$FollowTween.interpolate_property(self, "position", null, leader.position_history[follow_distance], 0.1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
#
#			$FollowTween.start()
#
#			motion = Vector2(make_one(position.x - previous_position.x), make_one(position.y - previous_position.y))
#
#			match motion:
#				Vector2(0, -1):
#					direction = "up"
#				Vector2(1, -1):
#					direction = "rightup"
#				Vector2(1, 0):
#					direction = "right"
#				Vector2(1, 1):
#					direction = "rightdown"
#				Vector2(0, 1):
#					direction = "down"
#				Vector2(-1, 1):
#					direction = "leftdown"
#				Vector2(-1, 0):
#					direction = "left"
#				Vector2(-1, -1):
#					direction = "leftup"
#		#	if t%20 > t%15 : print($AnimatedSprite.playing)
#			$AnimatedSprite.animation = direction
#
#			$AnimatedSprite.speed_scale = 1.3
#		#	if t%20 == 0:
#			if motion.length() > 0:
#				$AnimatedSprite.playing = true
#			else:
#				$AnimatedSprite.playing = false
#				$AnimatedSprite.frame = 0
#
#			in_water = leader.in_water_history[follow_distance]
#			set_in_water(in_water)
#
##			previous_position = position
			
			
func _tick():
	print(speed)
	if controlled_by == BOT:
		$FollowTween.interpolate_property(self, "position", null, leader.position_history[follow_distance], 0.1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	
		$FollowTween.start()
		
		motion = Vector2(make_one(int(position.x) - int(previous_position.x)), \
				make_one(int(position.y) - int(previous_position.y)))
		
		match motion:
			Vector2(0, -1):
				direction = "up"
			Vector2(1, -1):
				direction = "rightup"
			Vector2(1, 0):
				direction = "right"
			Vector2(1, 1):
				direction = "rightdown"
			Vector2(0, 1):
				direction = "down"
			Vector2(-1, 1):
				direction = "leftdown"
			Vector2(-1, 0):
				direction = "left"
			Vector2(-1, -1):
				direction = "leftup"
	#	if t%20 > t%15 : print($AnimatedSprite.playing)
		$AnimatedSprite.animation = direction
		
		$AnimatedSprite.speed_scale = 1.3
	#	if t%20 == 0:
		if motion.length() > 0:
			$AnimatedSprite.playing = true
		else:
			$AnimatedSprite.playing = false
			$AnimatedSprite.frame = 0
		
		if in_water != leader.in_water_history[follow_distance]:
			in_water = leader.in_water_history[follow_distance]
			set_in_water(in_water)
		
		previous_position = position

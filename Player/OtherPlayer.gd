extends "res://Player/Player.gd"

var follow_distance = 5

onready var leader = get_node("../Player")

export(bool) var spawn_with_p1 = true

func _ready():
	if spawn_with_p1:
		position = Vector2(global.get_player(1).position.x, global.get_player(1).position.y - 1)

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
	# place orange at the player
	position = global.get_player(1).position
	# for when the scene switches
	$AnimationPlayer.play("appear")
	yield(get_tree().create_timer(0.2), "timeout")
	set_process(true)
	TickManager.set_tick(self, true)
	
	

func _process(delta):
	
	# if other cases unused, use set_process to make this not happen if this
	#  is controlled by a bot
	match controlled_by:
		PERSON:
			previous_position = position
			#if not get_owner().get_node("HUD/Diag").visible:
			if not frozen:
				get_inputs()
			else:
				# stop player when diag box is up.
				motion = Vector2(0,0)
		#	motion = motion.normalized()
			move_and_animate()
			
			# pushable props have bitmask 18, and we do want people to push them
			# here is 0th and 18th bit
			collision_layer = 0b1000000000000000001
		BOT:
			pass
			
func _tick():
	
	if controlled_by == BOT:
		if frozen:
			return
		$FollowTween.interpolate_property(self, "position", null, leader.position_history[follow_distance], 0.1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	
		$FollowTween.start()
		
		motion = Vector2(make_one(int(position.x) - int(previous_position.x)), \
				make_one(int(position.y) - int(previous_position.y)))
		
		match motion:
			Vector2(0, -1):
				direction = Direction.UP
			Vector2(1, -1):
				direction = Direction.RIGHTUP
			Vector2(1, 0):
				direction = Direction.RIGHT
			Vector2(1, 1):
				direction = Direction.RIGHTDOWN
			Vector2(0, 1):
				direction = Direction.DOWN
			Vector2(-1, 1):
				direction = Direction.LEFTDOWN
			Vector2(-1, 0):
				direction = Direction.LEFT
			Vector2(-1, -1):
				direction = Direction.LEFTUP
	#	if t%20 > t%15 : print($AnimatedSprite.playing)
		$AnimatedSprite.animation = direction_enum_to_string[direction]
		
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

		# pushable props have bitmask 18, and we dont want bots to push them
		collision_layer = 0b1

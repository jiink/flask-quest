extends Node2D

enum {GREEN, ORANGE}
export(int, "GREEN", "ORANGE") var player_mode

var rot =   0.0
var rot_v = 0.0

var rot_speed = 0.55
var max_rot_speed = 4.0
var rot_friction = .85

var left_action
var right_action

var shielded = false
var shield_time = 0.4
var shield_delay = 0.4

func _ready():
	# update which player the orange pawn is controlled by
	# in 2 player mode he is controlled by player 2
	if PlayerStats.player_count == 1:
		set_player_mode(1)
	elif PlayerStats.player_count > 1:
		if player_mode == ORANGE:
			set_player_mode(2)

	# set color (for colorblind support)
	print(player_mode)
	match player_mode:
		GREEN:
			$Sprite.modulate = global.GREEN_COLOR
		ORANGE:
			$Sprite.modulate = global.ORANGE_COLOR

	$ShieldTimer.connect("timeout", self, "shield_timer_timeout")
	get_parent().connect("stopped", self, "dodging_stopped")
	get_parent().connect("started", self, "dodging_started")

	dodging_started()
	
func move(delta):
	rot_v =  clamp(rot_v, -max_rot_speed, max_rot_speed)
	if Input.is_action_pressed(left_action):
		rot_v -= rot_speed * Input.get_action_strength(left_action)
	elif Input.is_action_pressed(right_action):
		rot_v += rot_speed * Input.get_action_strength(right_action)
	else:
		rot_v *= rot_friction 
	
	rot += rot_v*delta*60
	set_rotation_degrees(rot)
	
	if $ShieldDelay.is_stopped():
		if Input.is_action_just_pressed("confirm") and not shielded:
			shielded = true
			$InstaShield.visible = true
			$ShieldTimer.start(shield_time)
			$ShieldSound.play()
	
	if not get_node_or_null("AudioStreamPlayer2D"):
		return
	# sound
	# rot_v from about -4.5 to 4.5
	var v = abs(rot_v)
	if v > 0.1:
		$AudioStreamPlayer2D.volume_db = -1/v
		# eh 1 to 2 or something
		$AudioStreamPlayer2D.pitch_scale = 1.5 + v * 0.1
		if not $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.playing = true
	else:
		if $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.playing = false

func set_player_mode(p):
	match p:
		1:
			left_action = "left"
			right_action = "right"
		2:
			left_action = "left2"
			right_action = "right2"
		_:
			print("warning: pawn got its player mode set wrong, at %s" % p)

func shield_timer_timeout():
	shielded = false
	$InstaShield.visible = false
	$ShieldDelay.start(shield_delay)

func dodging_stopped():
	if has_node("AudioStreamPlayer2D"):
		$AudioStreamPlayer2D.playing = false
	rot = 0
	rot_v = 0
	set_rotation_degrees(0)

func dodging_started():
	shielded = true
	$AnimationPlayer.play("invincible")
	$InvincibilityTimer.start()
	yield($InvincibilityTimer, "timeout")
	$AnimationPlayer.stop()
	shielded = false

extends AnimatedSprite


func interact():
	PlayerStats.green_hp = PlayerStats.green_max_hp
	global.get_player().do_floaty_text("Health restored!")
	$ApprovalNoise.play()

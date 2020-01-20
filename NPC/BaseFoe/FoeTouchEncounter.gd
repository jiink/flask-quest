extends KinematicBody2D

var base_name

func _ready():
	# enemy must have TouchArea area2d to detect if the player touched the enemy
	$TouchArea.connect("body_entered", self, "body_entered")
	
	base_name = name.replace("@", "")
	for i in range(9):
		base_name = base_name.replace(str(i), "")

func body_entered(body):
	if body == global.get_player():
		if not global.get_player().get("invincible"):
			trigger()

func trigger():
	set_process(false)
	TickManager.set_tick(self, false)
	global.start_battle([base_name])

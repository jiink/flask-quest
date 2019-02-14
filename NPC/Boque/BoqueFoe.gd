extends Node2D

func _ready():
	$AnimationPlayer.play("Idle")
	$AnimationPlayer.seek(rand_range(0,0.9))
	
func _process(delta):
	position.x += rand_range(-1,1)
	position.y += rand_range(-1,1)
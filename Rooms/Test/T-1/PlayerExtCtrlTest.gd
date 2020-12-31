extends Sprite

onready var player = global.get_player(1)

func interact():
	player.set_controlled_by(player.EXTERNAL)
	$AnimationPlayer.play("main")
	yield($AnimationPlayer, "animation_finished")
	player.set_controlled_by(player.PERSON)

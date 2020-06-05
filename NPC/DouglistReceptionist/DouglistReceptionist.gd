extends Node2D

var actively_staring = false
onready var player = global.get_player()

enum {LEFT, LEFT_DOWN, DOWN, RIGHT_DOWN, RIGHT}

func set_actively_staring(option):
	if option:
		add_to_group("tick")
	else:
		remove_from_group("tick")

func _tick():
	look_at(player.position)
	var r = rotation + PI/2
	# print("%s PI" % [r/3.14])
	if (r > PI*.5) and (r <= 2*PI/3):
		$Sprite.frame = RIGHT
	elif (r > 2*PI/3) and (r <= 5*PI/6):
		$Sprite.frame = RIGHT_DOWN
	elif (r > 5*PI/6) and (r <= PI):
		$Sprite.frame = DOWN
	elif r > PI:
		$Sprite.frame = LEFT_DOWN
	else:
		$Sprite.frame = RIGHT
	rotation = 0

func interact():
	DiagHelper.start_talk(self)

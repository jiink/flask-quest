extends Sprite

func interact():
	DiagHelper.start_talk(self, "Event")

func accept():
	global.start_scene_switch("res://Cutscenes/MurkMonsterSequence/MurkMonsterSequence.tscn", \
	Vector2(0,0))

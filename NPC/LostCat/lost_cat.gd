extends "res://NPC/NPCBasic/NPCBasic.gd"

onready var old_woman = get_tree().get_current_scene().get_node("YSort/NPC/OldWoman")

func _ready():
	global.connect("battle_won", self, "_on_battle_won")

func interact():
	if not old_woman.player_searching:
		DiagHelper.start_talk(self, "DiagPiece")
	else:
		DiagHelper.start_talk(self, "PlayerFound")

func engage_battle():
	global.start_battle(["LostCat"])
	
func _on_battle_won():
	old_woman.current_dialogue = "Finished"
	self.queue_free()

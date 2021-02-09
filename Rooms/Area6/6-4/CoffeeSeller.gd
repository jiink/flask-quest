extends "res://NPC/NPCBasic/NPCBasic.gd"

var should_battle 


func save(save_game):
	save_game.data["6-1_poppy_dog_requested"] = should_battle

func load(save_game):
	should_battle = save_game.data["6-1_poppy_dog_requested"]
	
func interact():
	if should_battle:
		DiagHelper.start_talk(self, "Battle")
	else:
		DiagHelper.start_talk(self, "General")

func battle():
	ItemManager.give_item("poppy_dog")

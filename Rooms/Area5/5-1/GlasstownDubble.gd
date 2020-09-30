extends "res://NPC/NPCWalking/NPCWalking.gd"

enum Missions {
	GRASSBULB,
	GRASSBULB_REMINDER,
	GLITTER,
	GLITTER_REMINDER,
	TOILETPAPER,
	TOILETPAPER_REMINDER,
	TORTILLA,
	TORTILLA_REMINDER,
	BOMB,
	BOMB_REMINDER,
	PLANT_BOMB,
	PLANT_BOMB_REMINDER
}

var current_mission = Missions.GRASSBULB

const SAVE_KEY = "5-1_dubble_"

onready var scene_root = get_tree().get_current_scene()

func save(save_game):
	save_game.data[SAVE_KEY + "quest_status"] = current_mission

func load(save_game):
	current_mission = save_game.data[SAVE_KEY + "quest_status"]
	
func interact():
	if interactable:
#		print("****************Current mission = %s" % current_mission)
		if ItemManager.inventory.has("orange_grassbulbs_item"):
			current_mission = Missions.GLITTER
		elif ItemManager.inventory.has("glitter_item"):
			current_mission = Missions.TOILETPAPER
		elif ItemManager.inventory.has("toilet_paper_item"):
			current_mission = Missions.TORTILLA
		elif ItemManager.inventory.has("tortured_tortilla_item"):
			current_mission = Missions.BOMB
		elif ItemManager.inventory.has("glasstown_bomb_item"):
			current_mission = Missions.PLANT_BOMB
			
#		print("****************New current mission = %s" % current_mission)
		
		match current_mission:
			Missions.GRASSBULB:
				DiagHelper.start_talk(self, "MissionGrassbulb")
				current_mission = Missions.GRASSBULB_REMINDER
			Missions.GRASSBULB_REMINDER:
				DiagHelper.start_talk(self, "MissionGrassbulbReminder")
				
			Missions.GLITTER:
				DiagHelper.start_talk(self, "MissionGlitter")
				current_mission = Missions.GLITTER_REMINDER
				ItemManager.toss_item('orange_grassbulbs_item', ItemManager.ANY, true)
			Missions.GLITTER_REMINDER:
				DiagHelper.start_talk(self, "MissionGlitterReminder")

			Missions.TOILETPAPER:
				DiagHelper.start_talk(self, "MissionToiletpaper")
				current_mission = Missions.TOILETPAPER_REMINDER
				ItemManager.toss_item('glitter_item', ItemManager.ANY, true)
			Missions.TOILETPAPER_REMINDER:
				DiagHelper.start_talk(self, "MissionToiletpaperReminder")

			Missions.TORTILLA:
				DiagHelper.start_talk(self, "MissionTortilla")
				current_mission = Missions.TORTILLA_REMINDER
				ItemManager.toss_item('toilet_paper_item', ItemManager.ANY, true)
			Missions.TORTILLA_REMINDER:
				DiagHelper.start_talk(self, "MissionTortillaReminder")

			Missions.BOMB:
				DiagHelper.start_talk(self, "MissionBomb")
				current_mission = Missions.BOMB_REMINDER
				ItemManager.toss_item('tortured_tortilla_item', ItemManager.ANY, true)
			Missions.BOMB_REMINDER:
				DiagHelper.start_talk(self, "MissionBombReminder")

			Missions.PLANT_BOMB:
				DiagHelper.start_talk(self, "MissionPlantBomb")
				current_mission = Missions.PLANT_BOMB_REMINDER
				ItemManager.toss_item('glasstown_bomb_item', ItemManager.ANY, true)
			Missions.PLANT_BOMB_REMINDER:
				DiagHelper.start_talk(self, "MissionPlantBombReminder")
				
func set_time_dawn():
	scene_root.fade_time_of_day(0)
	
func set_time_day():
	scene_root.fade_time_of_day(1)
	
func set_time_dusk():
	scene_root.fade_time_of_day(2)
	
func set_time_night():
	scene_root.fade_time_of_day(3)

func give_finished_bomb():
	ItemManager.give_item("glasstown_finished_bomb_item")

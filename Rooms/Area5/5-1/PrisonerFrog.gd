extends "res://NPC/NPCWalking/NPCWalking.gd"

onready var dubble = get_node("../Dubble")
onready var character_mover = get_node("CharacterMover")
var in_mission = false
var SAVE_KEY = "5-1_frog_"
enum MissionStates {
	INTRO
	LEAD_FROM_HOUSE
	LEAD_INTO_FOREST
	OPEN_DOOR
}

func save(save_game):
	save_game.data[SAVE_KEY + "current_mission_state"] = current_mission_state

func load(save_game):
	current_mission_state = save_game.data[SAVE_KEY + "current_mission_state"]
	setup(current_mission_state)
	
func setup(state):
	if dubble.current_mission == dubble.Missions.TOILETPAPER_REMINDER:
		in_mission = true
		match state:
			MissionStates.INTRO:
				character_mover.play("idle_in_room")
			MissionStates.LEAD_FROM_HOUSE:
				character_mover.play("exit_room")
			MissionStates.LEAD_INTO_FOREST:
				character_mover.play("lead_from_house")
			MissionStates.OPEN_DOOR:
				character_mover.play("lead_into_forest")
	else:
		in_mission = false
		character_mover.play("idle_in_room")

var current_mission_state = MissionStates.INTRO

func interact():
	if interactable:
		if dubble.current_mission == dubble.Missions.TOILETPAPER_REMINDER:
			in_mission = true
		if not in_mission:
			if dubble.current_mission < dubble.Missions.TOILETPAPER:
				DiagHelper.start_talk(self, "PreMission")
			if dubble.current_mission > dubble.Missions.TOILETPAPER_REMINDER:
				DiagHelper.start_talk(self, "PostMission")
		elif in_mission:
			match current_mission_state:
				MissionStates.INTRO:
					DiagHelper.start_talk(self, "Intro")
				MissionStates.LEAD_FROM_HOUSE:
					DiagHelper.start_talk(self, "LeadFromHouse")
				MissionStates.LEAD_INTO_FOREST:
					DiagHelper.start_talk(self, "LeadIntoForest")
				MissionStates.OPEN_DOOR:
					DiagHelper.start_talk(self, "OpenDoor")
				
func exit_house():
	character_mover.play("exit_room")
	current_mission_state = MissionStates.LEAD_FROM_HOUSE
			
func lead_from_house():
	character_mover.play("lead_from_house")
	current_mission_state = MissionStates.LEAD_INTO_FOREST
	
func lead_into_forest():
	character_mover.play("lead_into_forest")
	current_mission_state = MissionStates.OPEN_DOOR
	
func open_door():
	#This is where the actual door opens
	#Froggy enters it and you should too
	$"../LargeMetalDoor".set_door_open(true)
	character_mover.play("enter_door")

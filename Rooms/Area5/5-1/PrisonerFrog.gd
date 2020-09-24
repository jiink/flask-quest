extends "res://NPC/NPCWalking/NPCWalking.gd"

onready var dubble = get_node("../Dubble")
onready var character_mover = get_node("CharacterMover")
onready var path_follow = get_node("../../FrogPath/PathFollow2D")

var SAVE_KEY = "5-1_frog_"

# Whether the frog is directing the player in their toilet-paper mission
var in_mission = false

enum MissionStates {
	INTRO,
	LEAD_FROM_HOUSE,
	LEAD_INTO_FOREST,
	OPEN_DOOR,
	DOOR_OPENED,
	SUPERTUNNEL_EXITED
}
var current_mission_state = MissionStates.INTRO

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
				$"../LargeMetalDoor".set_door_open(false)
				character_mover.play("idle_in_room")
				$"TriggerArea/CollisionShape2D".set_deferred("disabled", true)
			MissionStates.LEAD_FROM_HOUSE:
				$"../LargeMetalDoor".set_door_open(false)
				path_follow.offset = 2831.36
				$"TriggerArea/CollisionShape2D".set_deferred("disabled", true)
			MissionStates.LEAD_INTO_FOREST:
				$"../LargeMetalDoor".set_door_open(false)
				path_follow.offset = 3158.96
				$"TriggerArea/CollisionShape2D".set_deferred("disabled", true)
			MissionStates.OPEN_DOOR:
				$"../LargeMetalDoor".set_door_open(false)
				path_follow.offset = 3616
				$"TriggerArea/CollisionShape2D".set_deferred("disabled", false)
			MissionStates.DOOR_OPENED:
				$"TriggerArea/CollisionShape2D".set_deferred("disabled", true)
				character_mover.play("enter_door")
				$"../LargeMetalDoor".set_door_open(true)
			MissionStates.SUPERTUNNEL_EXITED:
				$"../LargeMetalDoor".set_door_open(true)
				$"TriggerArea/CollisionShape2D".set_deferred("disabled", true)
				path_follow.offset = 3616
				close_door_dialogue()
	else:
		in_mission = false
		character_mover.play("idle_in_room")
		$"../LargeMetalDoor".set_door_open(false)

func interact():
	if interactable:
		if dubble.current_mission == dubble.Missions.TOILETPAPER_REMINDER:
			in_mission = true
		if not in_mission:
			if dubble.current_mission < dubble.Missions.TOILETPAPER_REMINDER:
				DiagHelper.start_talk(self, "PreMission")
			elif (ItemManager.inventory.has("toilet_paper_item")) or \
			(dubble.current_mission > dubble.Missions.TOILETPAPER_REMINDER):
				DiagHelper.start_talk(self, "PostMission")
		elif in_mission:
			match current_mission_state:
				MissionStates.INTRO:
					DiagHelper.start_talk(self, "Intro")
				MissionStates.LEAD_FROM_HOUSE:
					DiagHelper.start_talk(self, "LeadFromHouse")
				MissionStates.LEAD_INTO_FOREST:
					DiagHelper.start_talk(self, "LeadIntoForest")
				
func exit_house():
	character_mover.play("exit_room")
	current_mission_state = MissionStates.LEAD_FROM_HOUSE
			
func lead_from_house():
	character_mover.play("lead_from_house")
	current_mission_state = MissionStates.LEAD_INTO_FOREST
	
func lead_into_forest():
	character_mover.play("lead_into_forest")
	current_mission_state = MissionStates.OPEN_DOOR
	
func _on_TriggerArea_body_entered(body):
	if body == global.get_player():
		$"TriggerArea/CollisionShape2D".set_deferred("disabled", true)
		DiagHelper.start_talk(self, "OpenDoor")
	
# This is where the actual door opens
# Froggy enters it and you should too
func open_door():
	$"../LargeMetalDoor".animate_door_open(true)
	character_mover.play("enter_door")
	
func close_door_dialogue():
	DiagHelper.start_talk(self, "CloseDoor")
	
func close_door():
	$"../LargeMetalDoor".animate_door_open(false)
	
func go_home():
	character_mover.play("go_home")

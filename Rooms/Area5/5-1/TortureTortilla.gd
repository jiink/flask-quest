extends Sprite

onready var dubble = get_node("../../Dubble")

enum States{
	PRE_MISSION,
	MISSION,
	POST_MISSION
}

var current_mission_state = States.PRE_MISSION

func interact():
	print("YOU INTeraCTED WITH THE ROTIIALLL HERE IS YOUR PRIZE")
	if dubble.current_mission < dubble.Missions.TORTILLA_REMINDER:
		current_mission_state = States.PRE_MISSION
	elif dubble.current_mission == dubble.Missions.TORTILLA_REMINDER:
		current_mission_state = States.MISSION
	elif dubble.current_mission > dubble.Missions.TORTILLA_REMINDER:
		current_mission_state = States.POST_MISSION
	match current_mission_state:
		States.MISSION:
			ItemManager.give_item("tortured_tortilla_item")

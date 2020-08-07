extends Resource

class_name SaveGame

#export var game_version = ""
export(Dictionary) var data = {
	"1-1_lab_door_open": false,
	"1-1_orange_state": 2,
	"1-2_tv_event_seen": false,
	"2-1_malus_door_locked": true,
	"2-1_manhole_event_happened": false,
	"2-1_soda_boy_seen": false,
	"4-1_kicked_out_lobby": false,
	"5-1_dubble_intro_event_occured": false,
	"5-1_dubble_quest_status": 0,
	"5-1_time_of_day": 1,
	"dollars": 0,
	"event_seed": int(rand_range(1, 2048)),
	"green_hp": 100,
	"green_max_hp": 100,
	"inventory": [],
	"loadout": [],
	"orange_hp": 100,
	"orange_max_hp": 100,
	"party_members": [],
	"player_spawn_pos": Vector2( 274.93, 80.7559 ),
	"player_spawn_scene": "res://Cutscenes/Intro/IntroCutscene.tscn",
	"test_SaveTester": "blue",
	"test_SaveTester2": "blue",
	"test_SaveTester3": "blue"
}

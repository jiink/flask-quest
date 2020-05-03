extends Resource

class_name SaveGame

#export var game_version = ""
export(Dictionary) var data = {
	"1-1_lab_door_open": false,
	"1-1_orange_state": 2,
	"1-2_tv_event_seen": false,
	"2-1_malus_door_locked": true,
	"2-1_manhole_event_happened": false,
	"4-1_been_in_malus": false,
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
	"player_spawn_scene": "res://Rooms/Area1/1-1/1-1.tscn",
	"test_SaveTester": "blue",
	"test_SaveTester2": "blue",
	"test_SaveTester3": "blue"
}

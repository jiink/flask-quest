extends Node

var player_count = 1 # for "1 player" or "2 player"

var green_max_hp = 100
var green_hp = 100

var orange_max_hp = 100
var orange_hp = 100

var dollars = 0

enum {
	PERSON,
	BOT,
	EXTERNAL
}

func set_player_num(num):
	match num:
		1:
			print("switching to 1 player...")
			player_count = 1
			# if Orange exists make him a bot
			if get_tree().get_nodes_in_group("Player").size() > 1:
				var orange = global.get_player(2)
				orange.controlled_by = orange.BOT
		2:
			
			print("switching to 2 player...")
			player_count = 2
			# if Orange exists make him a person
			if get_tree().get_nodes_in_group("Player").size() > 1:
				var orange = global.get_player(2)
				orange.controlled_by = orange.PERSON

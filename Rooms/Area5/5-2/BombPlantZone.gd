extends Node2D

var SAVE_KEY = "5-2_bomb_"
onready var bomb = get_node("../YSort/Bomb")
var interacting_player = 1
var dubble_quest_status = 0
var bomb_planted = false

func save(save_game):
	save_game.data[SAVE_KEY + "planted"] = bomb_planted
	save_game.data[SAVE_KEY + "position"] = bomb.position
	
func load(save_game):
	bomb_planted = save_game.data[SAVE_KEY + "planted"]
	bomb.position = save_game.data[SAVE_KEY + "position"]
	dubble_quest_status = save_game.data["5-1_dubble_quest_status"]
	if bomb_planted:
		bomb.visible = true
	else:
		bomb.visible = false
	
func interact():
	# 11 is Dubble's last mission 
	if (dubble_quest_status == 11) and \
	(ItemManager.inventory.has("glasstown_finished_bomb_item")):
		var player = global.get_player(1)
		var bomb_position_modifier = Vector2(0,0)
		bomb_planted = true
		match player.direction:
			"up":
				bomb_position_modifier = Vector2(0,-8)
			"rightup":
				bomb_position_modifier = Vector2(6,-6)
			"right":
				bomb_position_modifier = Vector2(8,0)
			"rightdown":
				bomb_position_modifier = Vector2(6,6)
			"down":
				bomb_position_modifier = Vector2(0,8)
			"leftdown":
				bomb_position_modifier = Vector2(-6,6)
			"left":
				bomb_position_modifier = Vector2(-8,0)
			"leftup":
				bomb_position_modifier = Vector2(-6,-6)
		bomb.position = player.position + bomb_position_modifier + Vector2(0,-8)
		bomb.visible = true
		ItemManager.toss_item('glasstown_finished_bomb_item', ItemManager.ANY, true)
		MusicManager.change_music("res://Music/goodvibes-battle.ogg", true, 0)

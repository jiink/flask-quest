extends Node

const SaveGame = preload("res://Engine/Singletons/Save/SaveGame.gd")

var SAVE_FOLDER = "res://debug/save"
var SAVE_NAME_TEMPLATE = "save_%03d.tres"


var save_game = load(SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % 1))

#func _ready(): # HAHA don't do this, kids
#	yield(get_tree().create_timer(0.1), "timeout") 
#	load_from_save_station(1)


func save(id):
	
#	var save_game := SaveGame.new()
#	var save_file_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
#	var file = File.new()
#	if not file.file_exists(save_file_path):
#		print("save file %s doesn't exist" % save_file_path)
#		return
	
#	var save_game = load(save_file_path)
	
	for node in get_tree().get_nodes_in_group("save"):
		node.save(save_game)
#
#	var directory = Directory.new()
#	if not directory.dir_exists (SAVE_FOLDER):
#		directory.make_dir_recursive(SAVE_FOLDER)
#		print("!!!!!!!!!!!!!!!!!!! MADE DIRECTORRYYRYRYRYR")
#	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
#	var error = ResourceSaver.save(save_file_path, save_game)

#	if error != OK:
#		print("Couldn't write save %s to %s" % [id, save_file_path])

func load(id):
#	var save_file_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
#	var file = File.new()
#	if not file.file_exists(save_file_path):
#		print("save file %s doesn't exist" % save_file_path)
#		return
	
#	save_game = load(save_file_path)
	for node in get_tree().get_nodes_in_group("save"):
		node.load(save_game)

func save_from_save_station(id):
	
#	var save_game := SaveGame.new()
#	save_game = SaveGame.new()
	
	for node in get_tree().get_nodes_in_group("save"):
		node.save(save_game)
#	print("[[[[[[[[ %s" % get_tree().get_current_scene().filename)
#	print("{{{{{{{{ %s" % get_tree().get_edited_scene_root().filename)
#	print("(((((((( %s" % get_tree().get_current_scene().get_script().get_path().get_base_dir())
#	var the_pathhh = "%s/%s.tscn" % [get_tree().get_current_scene().get_script().get_path().get_base_dir(), get_tree().get_current_scene().name]
	print("spawn scene being saved: %s" % get_tree().get_current_scene().filename)
	save_game.data["player_spawn_scene"] = get_tree().get_current_scene().filename
	
	print("spawn position being saved: %s" % get_tree().get_nodes_in_group("Player")[0].position)
	save_game.data["player_spawn_pos"] = get_tree().get_nodes_in_group("Player")[0].position
	
	print("health being saved: %s/%s, %s/%s" % [$"/root/PlayerStats".green_hp, $"/root/PlayerStats".green_max_hp, $"/root/PlayerStats".orange_hp, $"/root/PlayerStats".orange_max_hp]) 
	save_game.data["green_hp"] = $"/root/PlayerStats".green_hp
	save_game.data["green_max_hp"] = $"/root/PlayerStats".green_max_hp
	save_game.data["orange_hp"] = $"/root/PlayerStats".orange_hp
	save_game.data["orange_max_hp"] = $"/root/PlayerStats".orange_max_hp
	print("Dollar amount being saved: %s" % [$"/root/PlayerStats".dollars])
	save_game.data["dollars"] = $"/root/PlayerStats".dollars
	
	
	print("inventory being saved: %s" % [$"/root/ItemManager".inventory])
	save_game.data["inventory"] = $"/root/ItemManager".inventory
	print("loadout being saved: %s" % [$"/root/ItemManager".loadout])
	save_game.data["loadout"] = $"/root/ItemManager".loadout
	
		
	var directory = Directory.new()
	if not directory.dir_exists (SAVE_FOLDER):
		directory.make_dir_recursive(SAVE_FOLDER)
		
	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	print("SAVING to %s" % save_path)
	var error = ResourceSaver.save(save_path, save_game)
	
	if error != OK:
		print("Couldn't write save %s to %s" % [id, save_path])


func load_from_save_station(id): # yeah im a role model and copied the other function becuase m
	var save_file_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	print("LOADING from %s" % save_file_path)
	var file = File.new()
	if not file.file_exists(save_file_path):
		print("save file %s doesn't exist" % save_file_path)
		return
	
	save_game = load(save_file_path)
	
	var spawn_scene = save_game.data["player_spawn_scene"]
	get_tree().change_scene(spawn_scene)
	
	yield(get_tree().create_timer(0.1), "timeout")
	
	var spawn_pos = save_game.data["player_spawn_pos"]
	get_tree().get_nodes_in_group("Player")[0].position = spawn_pos
	
	
#	for node in get_tree().get_nodes_in_group("save"):
#		node.load(save_game)
	
	$"/root/PlayerStats".green_hp = save_game.data["green_hp"]
	$"/root/PlayerStats".green_max_hp = save_game.data["green_max_hp"]
	$"/root/PlayerStats".orange_hp = save_game.data["orange_hp"]
	$"/root/PlayerStats".orange_max_hp = save_game.data["orange_max_hp"]
	$"/root/PlayerStats".dollars = save_game.data["dollars"]
	$"/root/ItemManager".inventory = save_game.data["inventory"]
	$"/root/ItemManager".loadout = save_game.data["loadout"]
	
	$"/root/MusicManager".update_music("level")

	global.emit_signal("scene_changed") # yep

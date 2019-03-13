extends Node

const SaveGame = preload("res://Engine/Singletons/Save/SaveGame.gd")

var SAVE_FOLDER = "res://debug/save"
var SAVE_NAME_TEMPLATE = "save_%03d.tres"

func save(id):
	
	var save_game := SaveGame.new()
	
	for node in get_tree().get_nodes_in_group("save"):
		node.save(save_game)
		
	var directory = Directory.new()
	if not directory.dir_exists (SAVE_FOLDER):
		directory.make_dir_recursive(SAVE_FOLDER)
		
	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var error = ResourceSaver.save(save_path, save_game)
	
	if error != OK:
		print("Couldn't write save %s to %s" % [id, save_path])

func load(id):
	var save_file_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var file = File.new()
	if not file.file_exists(save_file_path):
		print("save file %s doesn't exist" % save_file_path)
		return
	
	var save_game = load(save_file_path)
	for node in get_tree().get_nodes_in_group("save"):
		node.load(save_game)
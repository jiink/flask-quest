extends Node2D

onready var save_button = $"Control/SaveButton"  
onready var back_button = $"Control/BackButton"
onready var players = global.get_players()
onready var player_money = GameSaver.save_game.data["dollars"]
onready var player_area_file = GameSaver.save_game.data["player_spawn_scene"]
onready var player_current_area_file = get_tree().get_current_scene().filename
var saved = false
var regex = RegEx.new()

var player_area_dict = {
	"Test" : "Forbidden Lands",
	"Intro" : "Brand-new Life",
	"Area1" : "A1 Laboratories",
	"Area2" : "Lanetta City",
	"Area3" : "Lanetta Sewers",
	"Area4" : "Malus, Inc. HQ",
	"Area5" : "Glasstown",
	"Area6" : "Poppyhart",
	"Area7" : "Mt. Neracla",
	"Area8" : "Plumb Desert",
	"Area9" : "S.S. Auxovus",
	"Area10" : "UNABLE TO CONNECT TO LOCATOR SERVICES. PLEASE CONTACT A1 LABORATORIES."
}


func _ready():
	regex.compile("\/(.*?)\/")
	if players.size() > 0:
		players[0].set_frozen(true, true)
		print(players[0].frozen)
	save_button.connect("button_down", self, "_on_save_button_down")
	back_button.connect("button_down", self, "_on_back_button_down")
#	$Control.grab_focus()
	save_button.grab_focus()
	
	# Display the name of the area the save file remembers. If unable to aquire the
	# display name, just show the name used for the file.
	var area_code_name = convert_path_to_area_name(player_area_file)
	if player_area_dict.keys().has(area_code_name):
		$InfoLabel.text = "%s\n$%s" % [
			player_area_dict[area_code_name],
			player_money
		]
	else:
		$InfoLabel.text = "%s\n$%s" % [
			area_code_name,
			player_money
		]
	
func convert_path_to_area_name(path):
	var results = regex.search_all(path)
	var result = results[1]
	var area_name = result.get_string(1).replace("/","")
	return area_name
	
func _on_save_button_down():
	GameSaver.save_from_save_station()
	print("****GAME SAVED****")
	$InfoLabel.text = "%s\n$%s" % [
		player_area_dict[convert_path_to_area_name(get_tree().get_current_scene().filename)],
		player_money
	]
	if saved == false:
		saved = true
		$SaveAnimation.play("save")
func _on_back_button_down():
	close()

# func _input(event):
# 	get_tree().set_input_as_handled()

func close():
	players[0].set_frozen(false, true)
	queue_free()
	

# based off of godot's "Input Mapping GUI" demo project
extends Control

const INPUT_ACTIONS = [ "up", "down", "left", "right", "confirm", "cancel", "action", "special" ]
const CONFIG_FILE = "user://input.cfg"

var action
var button

func load_config():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err:
		for action_name in INPUT_ACTIONS:
			var action_list = InputMap.get_action_list(action_name)
			var scancode = OS.get_scancode_string(action_list[0].scancode)
			config.set_value("input", action_name, scancode)
		config.save(CONFIG_FILE)
	else:
		for action_name in config.get_section_keys("input"):
			var scancode = OS.find_scancode_from_string(config.get_value("input", action_name))
			var event = InputEventKey.new()
			event.scancode = scancode
			
			for old_event in InputMap.get_action_list(action_name):
				if old_event is InputEventKey:
					InputMap.action_erase_event(action_name, old_event)
			InputMap.action_add_event(action_name, event)

func save_to_config(section, key, value):
	# redefines a parameter
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err:
		print("Error code when laoding config file: ", err)
	else:
		config.set_value(section, key, value)
		config.save(CONFIG_FILE)


func wait_for_input(action_bind):
	action = action_bind
	
	button = get_node("Bindings").get_node(action).get_node("Button")
	
	set_process_input(true)

func _input(event):
	if event is InputEventKey:
		get_tree().set_input_as_handled()
		set_process_input(false)
		
		if not event.is_action("ui_cancel"):
			var scancode = OS.get_scancode_string(event.scancode)
			button.text = scancode
			
			for old_event in InputMap.get_action_list(action):
				InputMap.action_erase_event(action, old_event)
			
			InputMap.action_add_event(action, event)
			save_to_config("input", action, scancode)

func _ready():
	
	load_config()
	
	for action in INPUT_ACTIONS:
		var input_event = InputMap.get_action_list(action)[0]
		print("%s %s" % [action, input_event])
		print(input_event.scancode)
		
		var button = get_node("Bindings").get_node(action).get_node("Button")
		button.text = OS.get_scancode_string(input_event.scancode)
		button.connect("pressed", self, "wait_for_input", [action])
	
	
	set_process_input(false)
			
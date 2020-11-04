extends Node

###############################################
var debug_mode = true
###############################################

var launch_without_music = true

onready var debug_mode_watermark = preload("res://Engine/Debug/DebugModeWatermark.tscn")

func _ready():
	global.connect("scene_changed", self, "on_scene_change")
	on_scene_change()

	if launch_without_music:
		AudioServer.set_bus_mute(1, true)

func on_scene_change():
	if debug_mode:
		# add the watermark, creating the canvaslayer if there isnt already one
		var scene = get_tree().get_current_scene()
		var canvas
		var scene_has_canvas = false
		
		for child in scene.get_children():
			if child is CanvasLayer:
				scene_has_canvas = true
				canvas = child
				break
				
		if not scene_has_canvas:
			canvas = CanvasLayer.new()
			canvas.name = "NewDebugCanvas"
			scene.add_child(canvas)
			
		canvas.add_child(debug_mode_watermark.instance())


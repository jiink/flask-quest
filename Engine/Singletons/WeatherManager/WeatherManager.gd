#The WEATHER system.
# Allows you to gradually change weather in a natural way, shut it off instantly (if you're
# going, say, indoors), change the type of weather, weather color, etc.
#

extends Node

var weather_enabled

var current_weather = [ false, false ] #Rain and/or snow?

enum WeatherType{rain, snow}

onready var weather_visuals_rt = get_tree().get_current_scene().get_node_or_null("Camera/Rain")
onready var weather_visuals_rain = get_tree().get_current_scene().get_node_or_null("Camera/Rain/RainParticles")
onready var weather_visuals_snow = get_tree().get_current_scene().get_node_or_null("Camera/Rain/SnowParticles")

func _ready():
	global.connect("scene_changed", self, "_on_scene_changed")
	if not weather_visuals_rt:
		pass
	_on_scene_changed() # For initial scene (for debugging)
	
func start(preproc): # Starts weather with a customizable amount of preprocess time
	weather_visuals_rain.preprocess = preproc
	weather_visuals_snow.preprocess = preproc
	
	if current_weather[0] == true:
		weather_visuals_rain.emitting = true
		weather_visuals_rain.visible = true
	if current_weather[1] == true:
		weather_visuals_snow.emitting = true
		weather_visuals_snow.visible = true

func instant_start(): # Unhides active weather.
	pass

func instant_stop(stop_emitting:bool = false): # Makes weather invisible. Good for if you go indoors.
	pass
	
func interpolate_properties(rate = null, color = null, dir = null, speed = null):
	if rate:
		$Tween.interpolate_property() #etc.......
	
func change_type(new_type): # New type can be either 0 (rain) or 1 (snow) (AS OF RIGHT NOW)
	pass
	
func _on_scene_changed():
	current_weather = get_tree().get_current_scene().get("current_weather")
	start(10)

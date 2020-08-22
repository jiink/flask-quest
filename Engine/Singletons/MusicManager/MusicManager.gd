# The music system.
# Many soundtrack pieces have an "aftermath" length where the instruments die out near the end of 
# the track. At the beginning of this period, the beginning of the song should also start playing,
# on a different AudioStreamPlayer. A MusicTrack is two AudioStreamPlayers, labelled A and B.
# As stream player A enters the aftermath phase, stream player B starts the beginning of the song.
# Scripts can change what music is playing via the `change_music` function. When this is called,
# a new MusicTrack node is created with a 0% volume. Then, the old MusicTrack's volume will move 
# from 100% to 0% while the new one's transitions to 100%. Once this is complete, the old
# MusicTrack is disposed.

extends Node

var current_level_music
var current_battle_music
var current_custom_battle_music

var music_pos_marker = 0.0

var aftermath_length = 0.2

onready var focus

onready var current_song
# onready var old_song

# Instance one of these when a new piece of music needs to be played
onready var music_track_scene = preload("res://Engine/Singletons/MusicManager/MusicTrack.tscn")

var volume_setting = 100 # 0 to 100, exposed to settings menu
var volume = 0 # in dB, -80 is off

func _ready():
	_on_scene_changed() # For initial scene (for debugging)
	global.connect("scene_changed", self, "_on_scene_changed")

# `new_song` can be a string or AudioStream. `start_from_beginning` is boolean. If false,
# the new song will try to start where the old one currently is.
# `fade_time` is the number of seconds for the corss-fade between old and new songs
func change_music(new_song, start_from_beginning, fade_time):
	# If there is an old MusicTrack, tell it to die
	for c in get_children():
		if c.name.find("MusicTrack") != -1:
			c.die(fade_time)

	if new_song != null:
		# If `new_song` is a string, make it a loaded stream
		if typeof(new_song) == TYPE_STRING:
			new_song = load(new_song)

		# Figure out the start time of the new song based on `start_from_beginning`
		var start_time = 0.0
		if (not start_from_beginning) and (current_song != null):
			start_time = current_song.get_playback_position()

		# Make a new MusicTrack and initialize it
		var new_music_track = music_track_scene.instance()
		new_music_track.setup(new_song, start_time, fade_time)
		MusicManager.add_child(new_music_track)
		current_song = new_music_track
	else:
		current_song = null
	

# When a new scene is loaded, store the room's level and battle music
# and play the level music
func _on_scene_changed():
	var old_level_music = current_level_music
	#var old_battle_music = current_battle_music
	print("AAAAAAAAAAAAAAAAAA")
	current_level_music = get_tree().get_current_scene().get("level_music")
	current_battle_music = get_tree().get_current_scene().get("battle_music")
	if old_level_music != current_level_music:
		change_music(current_level_music, true, 2.0)
	

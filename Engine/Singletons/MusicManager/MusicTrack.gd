# A MusicTrack is two AudioStreamPlayers, labelled A and B.
# As stream player A enters the aftermath phase, stream player B starts the beginning of the song.
# A MusicTrack is only reposible for handling one song. It will not be changed.
extends Node

# This is linear, not db! It's also independent of the volume option. Range 0 to 1.
var local_linear_volume = 1.0 setget set_volume_linear
var start_time = 0.0
var fade_in_time = 0.0
onready var player_a = $AudioStreamPlayerA
onready var player_b = $AudioStreamPlayerB
onready var focused_player = player_a
onready var other_player = player_b
onready var track #= preload("res://Engine/looptest.ogg")
onready var track_length_no_aftermath
onready var timer = $Timer
onready var tween = $Tween

# Units are in seconds
var aftermath_lengths = {
	"labs-2" : 1.50,
	"labs" : 0.05,
	"goodvibes" : 13.517,
	"cannedcranium": 1.332,
	"maloffice": 3.996,
	"lanetta" : 1.869,
	"sewers" : 0.08,
	"odd": 0.0,
	"zzzzzz": 0.0,
	"looptest": 0.2
}

func setup(track_in, start_time_in, fade_in_time_in):
	track = track_in
	start_time = start_time_in
	fade_in_time = fade_in_time_in
	track_length_no_aftermath = track.get_length() - get_track_aftermath_length(track.get_path())


func _ready():
	# print("debug info ")
	# print(track.get_length())
	# print(track_length_no_aftermath)
	player_a.set_stream(track)
	player_b.set_stream(track)
	player_a.volume_db = -80
	player_b.volume_db = -80

	# Begin the fade-in
	if fade_in_time > 0.0:
		tween.interpolate_property(self, "local_linear_volume", 0.0, 1.0, fade_in_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
	else:
		player_a.volume_db = 0
		player_b.volume_db = 0

	player_a.play(start_time)
	print("done")

	
func get_track_aftermath_length(path_name):
	for key in aftermath_lengths:
		if path_name.find(key) > -1:
			return aftermath_lengths[key]
	print("couldn't get aftermath length!")
	return 0.0
	

func _physics_process(delta): # could this be a tick() (20 calls/sec) and be fine?
	# When the aftermath period is reached, begin the other streamplayer.
	if focused_player.get_playback_position() >= track_length_no_aftermath:
		# swap `focused_player` and `other_player`
		if focused_player == $AudioStreamPlayerA:
			focused_player = $AudioStreamPlayerB
			other_player = $AudioStreamPlayerA
		else:
			focused_player = $AudioStreamPlayerA
			other_player = $AudioStreamPlayerB
		focused_player.play(0.0)
		# for some reason, we must wait a short amount of time or else 
		# the focused_player will swap a couple more times rapidly!
		timer.start() 
		set_physics_process(false)
		yield(timer, "timeout")
		set_physics_process(true)
		

# The sound's volume will transition from 100% to 0% over `fade_out_time`, and then be deleted
func die(fade_out_time):
	if fade_out_time > 0.0:
		tween.interpolate_property(self, "local_linear_volume", null, 0.0, fade_out_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
	queue_free()


func set_volume_linear(v):
	var db = linear2db(v)
	player_a.set_volume_db(db)
	player_b.set_volume_db(db)

# Returns `get_playback_position()` of the focused stream player
func get_playback_position():
	return focused_player.get_playback_position()

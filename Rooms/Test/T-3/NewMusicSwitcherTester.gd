extends Node2D

export(AudioStream) var new_song
export(bool) var start_from_beginning
export(float) var fade_time

func interact():
	MusicManager.change_music(new_song, start_from_beginning, fade_time)

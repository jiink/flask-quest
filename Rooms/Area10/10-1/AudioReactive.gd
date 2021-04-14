extends TileMap

export(float) var multiplier = 0.04
export(float) var adder = 1
export(float) var muted_speed = 1
var previous_offset = 0
var muted
var music_bus = AudioServer.get_bus_index("Music")

#func tick():
#	muted = AudioServer.is_bus_mute(music_bus)

func _process(delta):
	muted = AudioServer.is_bus_mute(music_bus)
	if not muted:
		var music_vol = AudioServer.get_bus_peak_volume_left_db(1, 0)
		modulate = Color(music_vol * multiplier + adder, music_vol * multiplier + adder, music_vol * multiplier + adder)
	#	previous_offset = get_material().get_shader_param("custom_offset")
	#	get_material().set_shader_param("custom_offset", previous_offset + (music_vol * multiplier - adder))
	else:
		modulate = Color(1,1,1)

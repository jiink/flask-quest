extends Sprite


func _process(delta):
	var music_vol = AudioServer.get_bus_peak_volume_left_db(1, 0)
	get_material().set_shader_param("brightness", music_vol * 0.04 + 1)

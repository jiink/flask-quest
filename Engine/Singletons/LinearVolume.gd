extends AudioStreamPlayer

func set_volume_linear(v):
	var db = linear2db(v)
	set_volume_db(db)

func get_volume_linear():
	return db2linear(get_volume_db())

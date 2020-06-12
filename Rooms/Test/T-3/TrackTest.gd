extends AudioStreamPlayer

func set_volume_linear(v):
	var db = linear2db(v)
	set_volume_db(db)

	$LinearLabel.text = str(v)
	$DbLabel.text = str(db)
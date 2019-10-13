extends Label

var focus 
var to_display

func _process(delta):
	to_display = ""
	for i in range(4):
		focus = get_owner().get_child(i)
		to_display += "-%s-\nstream = %s\nplaying = %s\nvolume = %s\nplayback pos = %s\n" % [focus.name, focus.get_stream().get_path() if focus.get_stream() else null, focus.playing, focus.volume_db, focus.get_playback_position()]
		
	text = to_display
	
	$Label.text = "focus = %s" % str(get_owner().focus.name)
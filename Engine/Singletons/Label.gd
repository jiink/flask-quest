extends Label

var focus 
var to_display

var warning_said = false

func _ready():
	if not visible:
		set_process(false)

func _process(delta):
	if not warning_said:
		warning_said = true
		print("HEY THE MUSICMANAGER DEBUG LABEL IS RUNNING!!! is it supposed to be?")
	to_display = ""
	for i in range(4):
		focus = get_owner().get_child(i)
		to_display += "-%s-\nstream = %s\nplaying = %s\nvolume = %s\nplayback pos = %s\n" % [focus.name, focus.get_stream().get_path() if focus.get_stream() else null, focus.playing, focus.volume_db, focus.get_playback_position()]
		
	text = to_display
	
	$Label.text = "focus = %s" % str(get_owner().focus.name)
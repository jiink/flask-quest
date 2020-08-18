extends Node
# key, text
export(String) var key = ""
export(String, MULTILINE) var message = ""
export(float) var text_delay = null
export(Font) var font = null
export(bool) var no_face = false
export(String, "(none)", "orange", "stercus", "green", "ribbit", "dubble") var character = "(none)" 
export(String, "(none)", "neutral", "open_mouth", "side_mouth", "smile", "kawaii", "sad",
		"smug", "cry_tear", "cry_mourn", "grin", "big_eyed", "big_eyed2", "angry",
		"unique", "dot_eyes", "closeup", "smug2", "cry_recover", "cry_sob", "frown",
		"drunk", "yell", "nervous", "yell_outburst", "confused", "blush") var expression = "(none)"
export(Texture) var face_texture = null
export(AudioStream) var voice_sound = null
export(float) var voice_variation = -1.0
export(String) var function = ""
export(Array) var args
export(bool) var skippable = true
export(bool) var dont_unfreeze_player = false
export(bool) var interrupt = false

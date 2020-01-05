extends Node
# key, text
export(String) var key = ""
export(String) var message = ""
export(float) var text_delay = null
export(Font) var font = null
export(bool) var no_face = false
export(String, "(none)", "orange", "stercus") var character = "(none)" 
export(String, "(none)", "neutral", "openmouth", "sidemouth", "happy", "cute", "sad", "suspicious", "crying", "cryingloud", "grin", "bigsurprise", "biggersurprise", "angry", "misc", "surprise", "stare", "smug") var expression = "(none)"
export(Texture) var face_texture = null
#export(bool) var no_voice = false
export(AudioStream) var voice_sound = null
export(float) var voice_variation = -1.0
export(String) var function = ""
export(Array) var args
export(bool) var skippable = true
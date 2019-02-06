extends Node
# key, text
export(String) var key
export(String) var message
export(float) var text_delay = null
export(bool) var no_face = false
export(String, "(none)", "neutral", "openmouth", "sidemouth", "happy", "cute", "sad", "suspicious", "crying", "cryingloud", "grin", "bigsurprise", "biggersurprise", "angry", "misc", "surprise", "stare", "smug") var expression = "(none)"
export(Texture) var face_texture = null
export(String) var function = ""
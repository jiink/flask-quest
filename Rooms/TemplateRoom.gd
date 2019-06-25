extends Node

export(Texture) var battle_bg

export(AudioStream) var level_music
export(AudioStream) var battle_music

func _ready():
	
	global.battle_bg = battle_bg
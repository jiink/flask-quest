extends Node

export(Texture) var battle_bg

func _ready():
	get_node("/root/global").battle_bg = battle_bg
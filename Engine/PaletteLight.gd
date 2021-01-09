#replace this line with "tool" when you're ready!
extends Node2D

export(Texture) var sprite setget change_sprite
onready var light = get_node("Light")

func _ready():
	change_sprite(sprite)

func change_sprite(new_sprite):
	$Light.texture = new_sprite

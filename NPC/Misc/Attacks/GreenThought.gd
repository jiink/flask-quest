extends "res://NPC/BrainJar/ThoughtCloudPiece.gd"

func drop():
	dropping = true
	$Sprite.frame = 1
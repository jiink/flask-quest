extends Node2D

func _ready():
	$Sprite.playing = true

func interact():
	DiagHelper.start_talk(self)

func start_brainjar_event():
	print("let's pretend we started the event in which the brain in a jar appears")
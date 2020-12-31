extends "res://Rooms/TemplateRoom.gd"

var SAVE_KEY = "2-3_"

onready var player = global.get_player(1)
var douglas_intro_triggered = false
onready var douglas = $YSort/Douglas

var douglas_defeated = true # set to true in DouglasEvent when the battle is won

func _ready():
	$EventTrigger.connect("body_entered", self, "_on_EventTrigger_body_entered")



func _on_EventTrigger_body_entered(body):
	if (not douglas_intro_triggered) and body == global.get_player(1):
		douglas_intro_triggered = true
		yield(get_tree().create_timer(1.0), "timeout")
		$Throne/DecoyDouglas.explode()
		$DouglasEvent/AnimationPlayer.play("douglas_walk_in")
		yield($DouglasEvent/AnimationPlayer, "animation_finished")
		DiagHelper.start_talk($DouglasEvent)

func start_douglas_fight():
	$"CustomMusic/DougEntry".playing = false
	$CustomMusic.remove_from_group("tick") # so the custom music volume thing stops happening
	$CustomMusic.stop()

	global.start_battle(["Douglas"])

func save(save_game):
	save_game.data[SAVE_KEY + "douglas_defeated"] = douglas_defeated

func load(save_game):
	douglas_defeated = save_game.data[SAVE_KEY + "douglas_defeated"]
	if douglas_defeated:
		$DouglasEvent.douglas_defeated_setup()


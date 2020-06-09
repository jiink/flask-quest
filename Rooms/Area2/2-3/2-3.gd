extends "res://Rooms/TemplateRoom.gd"

onready var player = global.get_player(1)
var douglas_intro_triggered = false
onready var douglas = $YSort/Douglas

func _ready():
	add_to_group("tick")
	$EventTrigger.connect("body_entered", self, "_on_EventTrigger_body_entered")


func _tick():
	# the closer player is to douglas throne, the louder the music is
	# 1500y is -25db, 0y is 0db
	MusicManager.set_volume( -(player.position.y * 0.017))

func _on_EventTrigger_body_entered(body):
	if (not douglas_intro_triggered) and body == global.get_player(1):
		douglas_intro_triggered = true
		yield(get_tree().create_timer(1.0), "timeout")
		$Throne/DecoyDouglas.explode()
		$DouglasEvent/AnimationPlayer.play("douglas_walk_in")
		yield($DouglasEvent/AnimationPlayer, "animation_finished")
		DiagHelper.start_talk($DouglasEvent)

func start_douglas_fight():
	MusicManager.set_volume( 0)
	remove_from_group("tick") # so the custom music volume thing stops happening

	global.start_battle(["Douglas"])

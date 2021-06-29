extends Node2D


onready var players = global.get_players()
onready var anim_player = $AnimationPlayer


func _ready():
	if players.size() > 0:
		players[0].set_frozen(true, true)
		print(players[0].frozen)
	anim_player.play("intro")
	anim_player.connect("animation_finished", self, "on_anim_finished")

func close():
	players[0].set_frozen(false, true)
	queue_free()


func on_anim_finished(anim):
	if anim == "intro":
		close()

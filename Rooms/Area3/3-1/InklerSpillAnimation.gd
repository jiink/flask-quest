extends Sprite

var triggered = false

func _ready():
	$TriggerArea.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
		if ((body == global.get_player(1)) or (PlayerStats.player_count > 1 and body in get_tree().get_nodes_in_group("Player"))) and \
		not triggered:
			$AnimationPlayer.play("inkler_go_spill")
			triggered = true

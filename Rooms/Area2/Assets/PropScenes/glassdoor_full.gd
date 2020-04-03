extends Sprite

func _ready():
	$OnArea.connect("body_entered", self, "on_body_entered")
	$OnArea.connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	if body == global.get_player():
		$AnimationPlayer.play("open")

func on_body_exited(body):
	if body == global.get_player():
		$AnimationPlayer.play("close")

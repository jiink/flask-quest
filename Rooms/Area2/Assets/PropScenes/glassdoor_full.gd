extends Sprite

export(bool) var locked = false
onready var closed_collision = $StaticBody2D/CollisionShape2D

func _ready():
	$OnArea.connect("body_entered", self, "on_body_entered")
	$OnArea.connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	if body == global.get_player() and not locked:
		$AnimationPlayer.play("open")

func on_body_exited(body):
	if body == global.get_player() and not locked:
		$AnimationPlayer.play("close")

func lock(state):
	locked = state
	print(locked)
	closed_collision.set_deferred("disabled", !state)

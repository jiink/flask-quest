extends AnimatedSprite

func _ready():
	connect("animation_finished", self, "_on_animation_finish")
	play("default")
	$AudioStreamPlayer2D.play()

func _on_animation_finish():
	set_visible(false)
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()

extends Sprite

func _ready():
	$Particles2D.emitting = true

func _on_Timer_timeout():
	queue_free()

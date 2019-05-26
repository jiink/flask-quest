extends Sprite

func _ready():
	$AnimationPlayer.seek(randf() * $AnimationPlayer.current_animation_length)
extends Node2D

var num = 420

var vec = Vector2(0,0)

func _ready():
	vec = Vector2(randf()*2-1, -randf()*3-1.5)
	$Label.text = str(int(num))

func _process(delta):
	position += vec
	vec.y += 0.1

func _on_Timer_timeout():
	queue_free()
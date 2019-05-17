extends Node2D

var num = 420

var vec = Vector2(0,0)

func _ready():
	vec = Vector2(randf()*2-1, -randf()*3-1.5)
#	set_physics_process(true)

#	$Body.linear_velocity = Vector2(randf() * 5 - 2, -randf() * 10 - 5)
#	$Body.set_linear_velocity(Vector2(randf() * 100 - 50, -randf() * 200 - 100))
#	$Body/Label.text = str(num)
	$Label.text = str(int(num))

func _process(delta):
	position += vec
	print(vec)
	vec.y += 0.1

#func _physics_process(delta):
#	print($Body.get_linear_velocity())

func _on_Timer_timeout():
	queue_free()
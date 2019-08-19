extends Light2D

var t = 0
func _process(delta):
	t+=1
	if t%5==0: energy = randf()*0.3+0.6
# to be attached to the visuals spawned by the ingredient bag in the inventory
# simply makes them wobble to give them better visibility
extends Sprite

var t = 0
var unique = randf() * 3

func _process(delta):
	offset = Vector2(sin(t * 6 + unique) * 3, cos(t * 13.2 + unique) * 3)
	t += delta

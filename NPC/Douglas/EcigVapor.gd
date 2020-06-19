extends PathFollow2D

var speed = 50

func _ready():
	scale.x = 0
	$Tween.interpolate_property(self, "scale:x", 0.0, 1.0, 0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()

func _physics_process(delta):
	offset += speed * delta

extends Sprite


func interact():
	$Tween.interpolate_property(self.material, "shader_param/separation",
	0.0, 2.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

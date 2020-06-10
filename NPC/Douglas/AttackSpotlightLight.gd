extends "res://Engine/Battle/Dodger/Projectiles/GenericProjectile.gd"

enum{ LEFT, RIGHT }

var direction = RIGHT

# starts invisible, transitions to partially transparent (area2d disabled), waits, and then transitions to opaque and enables area2d
func _ready():
	set_modulate(Color(get_modulate().r, get_modulate().g, get_modulate().b, 0)) # 0 alpha
	set_monitoring(false)
	set_monitorable(false)

	$Tween.interpolate_property(self, "modulate:a", 0, 0.3, 0.4)
	$Tween.start()
	yield($Tween, "tween_completed")

	yield(get_tree().create_timer(0.8), "timeout")

	set_modulate(Color(get_modulate().r, get_modulate().g, get_modulate().b, 1))
	set_monitoring(true)
	set_monitorable(true)

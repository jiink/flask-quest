extends "res://Engine/Battle/Dodger/Projectiles/GenericProjectile.gd"

onready var wave_scene = preload("res://Engine/Battle/Dodger/Projectiles/BrainWave.tscn")

#func _ready():
#	emit_wave()
	
func _on_WaveTimer_timeout():
	emit_wave()
	$WaveTimer.start(2)

func emit_wave():
	var wave_instance = wave_scene.instance()
	add_child(wave_instance)

extends "res://NPC/BaseFoe/BaseFoeFoe.gd"

var explosion = preload("res://Engine/Battle/BigChemicalExplosion.tscn")

func attack_completed():
	if attacks_completed == 1:
		var damage_number = load("res://Engine/Battle/DamageNumber.tscn").instance()
		damage_number.num = "uuhh... i have a headcaeache"
		add_child(damage_number)
		for i in range(3):
			$BaseAnimationPlayer.play("hurt")
			yield(get_tree().create_timer(1.1), "timeout")
		var explosion_instance = explosion.instance()
		get_parent().add_child(explosion_instance)
		explosion_instance.position = position
		yield(get_tree().create_timer(.33), "timeout")
		die()

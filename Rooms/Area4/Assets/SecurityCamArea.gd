extends Area2D

var security_chasers_scene = preload("res://Rooms/Area4/Assets/SecurityChasers.tscn")



func _on_SecurityCamArea_body_entered(body):
	if body == global.get_player():
		print("%s entered THE CAMERA VIEW" % body.name)
		body.frozen = true
		
		var security_chasers = security_chasers_scene.instance()
		body.add_child(security_chasers)
		$AnimationPlayer.play("disabled")
		$CollisionShape2D.set_deferred("disabled", true)

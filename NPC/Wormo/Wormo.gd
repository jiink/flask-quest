extends KinematicBody2D

export(int) var follow_dist = 100
export(int) var speed = 24

var target_dist
var moving = false


onready var target = get_tree().get_nodes_in_group("Player")[0]

func _process(delta):
	target_dist = get_global_transform().origin.distance_to(target.get_global_transform().origin)
	if target_dist < follow_dist:
			if not is_touching_player():
				moving = true
				var angle = target.get_global_transform().origin.angle_to_point(get_global_transform().origin)
				$Sprite.flip_h = abs(angle) >= PI*0.5
				move_and_slide(Vector2(speed, 0).rotated(angle))
			else:
				queue_free()
				$"/root/global".start_battle(["Wormo", "Wormo", "Wormo"])
	else:
		moving = false
		
	if moving:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("default")
	else:
		if $AnimationPlayer.is_playing():
			$Sprite.frame = 0
			$AnimationPlayer.stop()
			
func is_touching_player():
	return $CollisionShape2D.get_global_transform().origin.distance_to(target.get_global_transform().origin) < 16
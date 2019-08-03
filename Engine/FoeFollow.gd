extends KinematicBody2D

export(int) var follow_distance = 100
export(int) var speed = 24

var target_distance
var chasing = false
var base_name
onready var target = global.get_player()

func _ready():
	base_name = name.replace("@", "")
	for i in range(9):
		base_name = base_name.replace(str(i), "")
		
func _process(delta):
	if target:
		target_distance = get_global_transform().origin.distance_to(target.get_global_transform().origin)
		if target_distance < follow_distance:
				if not is_touching_player():
					chasing = true
					var angle = target.get_global_transform().origin.angle_to_point(get_global_transform().origin)
					$Sprite.flip_h = abs(angle) >= PI*0.5
					move_and_slide(Vector2(speed, 0).rotated(angle))
				else:
					if not target.get("invincible"):
						trigger()
		else:
			chasing = false
		
			
func is_touching_player():
	return $CollisionShape2D.get_global_transform().origin.distance_to(target.get_global_transform().origin) < 16

func trigger():
	set_process(false)
	$"/root/global".start_battle([base_name])
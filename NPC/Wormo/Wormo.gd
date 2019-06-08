extends KinematicBody2D

export(int) var follow_distance = 100
export(int) var speed = 24

var target_distance
var moving = false
var base_name
onready var target = get_tree().get_nodes_in_group("Player")[0]

func _ready():
	base_name = name.replace("@", "")
	for i in range(9):
		base_name = base_name.replace(str(i), "")
		
func _process(delta):
	target_distance = get_global_transform().origin.distance_to(target.get_global_transform().origin)
	if target_distance < follow_distance:
			if not is_touching_player():
				moving = true
				var angle = target.get_global_transform().origin.angle_to_point(get_global_transform().origin)
				$Sprite.flip_h = abs(angle) >= PI*0.5
				move_and_slide(Vector2(speed, 0).rotated(angle))
			else:
				trigger()
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

func trigger():
	set_process(false)
	$"/root/global".start_battle([base_name])
extends Sprite

export(bool) var left_open = true
export(bool) var right_open = true
var jump_speed = 0.3
var jump_dist = 48
var jump_height = 4

onready var green = global.get_player(1)

var default_pos
var random_offset = Vector2(0,0)

func _ready():
	default_pos = position
	
	var possible_frames = (hframes * vframes) - 1
	if possible_frames > 0:
		randomize()
		frame = randi() % (possible_frames + 1)
		
	$JumpZoneLeft.connect("body_entered", self, "_on_Left_body_entered")
	$JumpZoneRight.connect("body_entered", self, "_on_Right_body_entered")
	$JumpZoneLeft/CollisionShape2D.set_deferred("disabled", !left_open)
	$JumpZoneRight/CollisionShape2D.set_deferred("disabled", !right_open)

func _tick():
	random_offset = Vector2(0, randi() % 2)
	offset = random_offset

func _on_Left_body_entered(body):
	if body == global.get_player(1):
		jump(false)
		
func _on_Right_body_entered(body):
	if body == global.get_player(1):
		jump(true)
		
func jump(is_right):
	var destination_pos
	var mid_pos
	if is_right:
		mid_pos = Vector2(jump_dist/2, -jump_height)
		destination_pos = Vector2(jump_dist, 0)
	else:
		mid_pos = Vector2((-jump_dist)/2, -jump_height)
		destination_pos = Vector2(-jump_dist, 0)
		
	green.frozen = true
	
	for col in get_tree().get_nodes_in_group("jump_col"):
		col.set_deferred("disabled", true)
	
	var original_green_pos = green.position

	$Tween.interpolate_property(green, "position", 
	null, original_green_pos + mid_pos, jump_speed/2, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	$Tween.interpolate_property(green, "position", 
	null, original_green_pos + destination_pos, jump_speed/2, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	green.frozen = false

	for col in get_tree().get_nodes_in_group("jump_col"):
		col.set_deferred("disabled", false)
		

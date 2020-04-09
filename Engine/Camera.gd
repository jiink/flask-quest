extends Camera2D

export(bool) var follow_player = true
 
func _ready():
	_start_position = offset
	_start_rotation = rotation
	_trauma = 0.0
 
func _process(delta):
	if follow_player:
		position = get_node("../YSort/Player").position
	
	if _trauma > 0:
		_decay_trauma(delta)
		_apply_shake()
		
# ------------ screenshake script ------------ 
# https://twitter.com/_Azza292
# MIT License
 
export var decay_rate = 2
export var max_roll = 0.05
export var max_offset = 6
 
var _start_position
var _start_rotation
var _trauma
 
 
func shake(amount = 10): # formerly "add_trauma"
	_trauma = min(_trauma + amount, 1)

func _decay_trauma(delta):
	var change = decay_rate * delta
	_trauma = max(_trauma - change, 0)
 
func _apply_shake():
	var shake = _trauma * _trauma
	var roll = max_roll * shake * _get_neg_or_pos_scalar()
	var o_x = max_offset * shake * _get_neg_or_pos_scalar()
	var o_y = max_offset * shake * _get_neg_or_pos_scalar()
	offset = _start_position + Vector2(o_x, o_y)
	rotation = _start_rotation + roll
 
func _get_neg_or_pos_scalar():
		return rand_range(-1.0, 1.0)

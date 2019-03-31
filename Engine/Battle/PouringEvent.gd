extends Node2D

onready var battle = get_node("..")
onready var liq_pour = get_node("orangepouring/LiquidPouring")
onready var liq = get_node("GreenFlask/LiquidFilled")

var fill_perc = 0.0
var stopped = false
var fill_speed = 0.5

func _ready():
	visible = false

func _process(delta):
	if battle.state == "pouring":
		if not stopped:
			fill_perc += fill_speed
			update_liq(fill_perc)
		
func update_liq(perc):
	# 0-100 to 0-40
	var new_size = perc * (40.0/100.0)
	liq.rect_scale.y = new_size
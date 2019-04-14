extends Node2D

onready var battle = get_node("..")
onready var liq_pour = get_node("orangepouring/LiquidPouring")
onready var liq = get_node("GreenFlask/LiquidFilled")

var fill_perc = 0.0
var stopped = false

var target_perc = 50.0
var fill_speed = 0.8

var effectiveness = 1.0
var done_sliding = false

var firt = false

func _ready():
	visible = false
	$AnimationPlayer.connect("animation_finished", self, "slide_finished")

func _process(delta):
	if battle.state == battle.POURING:
		if not firt:
			firt = true
			$AnimationPlayer.play("slide in")
		
		if done_sliding:
			# 0-100 to 216-96
			# output = output_start + ((output_end - output_start) / (input_end - input_start)) * (input - input_start)
			$FillTarget.position.y = 216.0 + ((96.0 - 216.0) / (100.0 - 0.0)) * (target_perc - 0.0)
			if not stopped:
				fill_perc += fill_speed
				update_liq(fill_perc)
				
				
				if Input.is_action_just_pressed("a"):
					stopped = true
					var error = (abs(target_perc - fill_perc) / fill_perc)
					effectiveness = 1.0 - clamp(error, 0, 1.0)
					print("effectiveness: %s" % effectiveness)
					#battle.start_chem_attack()
					done_sliding = false
					
					stop()
	else:
		firt = false
func update_liq(perc):
	# 0-100 to 0-40
	var new_size = perc * (40.0/100.0)
	liq.rect_scale.y = new_size

func slide_finished(anim):
	#print("hey sliding finished, current anim = %s" % $AnimationPlayer.current_animation )
	done_sliding = true
	if anim == "slide out":
		visible = false
		
		print("hey the pouring guys should be inbvidible now")
		battle.start_chem_attack()
	#firt = false
	
func reset():
	visible = false
	fill_perc = 0.0
	stopped = false

func stop():
	$AnimationPlayer.play("slide out")
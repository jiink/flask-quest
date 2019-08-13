extends Node2D

onready var battle = get_node("..")
onready var liq_pour = get_node("orangepouring/LiquidPouring")
onready var liq = get_node("GreenFlask/LiquidFilled")

var fill_perc = 0.0
var stopped = false

var output_damage = 0
var done_sliding = false

var firt = false
var overflowed = false

var chemical

func _ready():
	visible = false
	$AnimationPlayer.connect("animation_finished", self, "slide_finished")
	liq.value = 0
	

func _process(delta):
	if battle.state == battle.POURING:
		if not firt:
			firt = true
			$AnimationPlayer.play("slide in")
			visible = true
			chemical = battle.get_node("BattleChoices/Chemicals").get_child(battle.selected_chem)
		
		if done_sliding:
			
			# 0-100 to 216-96
			# output = output_start + ((output_end - output_start) / (input_end - input_start)) * (input - input_start)
			$FillTarget.position.y = 216.0 + ((96.0 - 216.0) / (100.0 - 0.0)) * (chemical.fill_target - 0.0)
			if not stopped:
				fill_perc += chemical.fill_speed * 60 * delta
				update_liq(fill_perc)
				
				
				if Input.is_action_just_pressed("a") or fill_perc > 100:
					if fill_perc > 100:
						overflowed = true
						
					stopped = true
					output_damage = 0
					
					if fill_perc < chemical.fill_target + chemical.fill_tolerance and fill_perc > chemical.fill_target - chemical.fill_tolerance:
						
						var dist_to_target = float(abs(chemical.fill_target - fill_perc)) / float(chemical.fill_target)
						output_damage = chemical.min_damage + (chemical.damage - chemical.min_damage) * (1 - dist_to_target)
						
						if int(fill_perc) == chemical.fill_target:
							output_damage = chemical.damage * chemical.perfect_multiplier
						output_damage = int(output_damage)
#						print("damage info:\nfill_perc: %s\ndist_to_target: %s\noutput_damage: %s" % [fill_perc, dist_to_target, output_damage])
					
					done_sliding = false
					
					stop()
	else:
		firt = false
func update_liq(perc):
	liq.value = perc

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
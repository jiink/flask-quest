extends Node2D

onready var battle = get_node("..")
onready var liq_pour = get_node("PouringFlask/LiquidPouring")
onready var liq = get_node("FillingFlask/LiquidFilled")

var fill_perc = 0.0
var stopped = false

var output_effectiveness = 0
var done_sliding = false

var firt = false
var overflowed = false

var chemical

func _ready():
	visible = false
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finish")
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
				
				
				if Input.is_action_just_pressed("confirm") or fill_perc > 100:
					if fill_perc > 100:
						overflowed = true
						
					stopped = true
					output_effectiveness = 0
					
					if fill_perc < chemical.fill_target + chemical.fill_tolerance and fill_perc > chemical.fill_target - chemical.fill_tolerance:
						
						var dist_to_target = float(abs(chemical.fill_target - fill_perc)) / float(chemical.fill_target)
						output_effectiveness = chemical.min_effectiveness + (chemical.effectiveness - chemical.min_effectiveness) * (1 - dist_to_target)
						
						# perfect
						if int(fill_perc) == chemical.fill_target:
							output_effectiveness = chemical.effectiveness * chemical.perfect_multiplier
						
						# pass it around to effects for the effectiveness to be
						# modified by them
						# this could be replaced with a group, i guess.
						for child in $FillingFlask.get_children():
							if child.has_method("modify_pour_effectiveness"):
								output_effectiveness = child.modify_pour_effectiveness(output_effectiveness)
						
						print("REREREREREREReffectiveness info: fill_perc: %s\ndist_to_target: %s | output_effectiveness: %s" % [fill_perc, dist_to_target, output_effectiveness])
					
					done_sliding = false
					
					stop()
	else:
		firt = false

func update_liq(perc):
	liq.value = perc

func on_animation_finish(anim):
	#print("hey sliding finished, current anim = %s" % $AnimationPlayer.current_animation )
	done_sliding = true
	if anim == "slide out":
		visible = false
		
		print("hey the pouring guys should be inbvidible now")
		battle.start_chem_attack()
	
#	elif anim == "pouringflask slide out":
#
	#firt = false
	
func reset():
	visible = false
	$FillTarget.visible = true
	fill_perc = 0.0
	stopped = false

func stop():
	if chemical.category == chemical.DEFENSE:
		# make the pourer slide away, spawn the effect on the filled, and then \
		#  make the filled guy slide away and then we're done
		$FillTarget.visible = false
		$AnimationPlayer.play("pouringflask slide out")
		# wait for the slide away to finis
		yield($AnimationPlayer, "animation_finished")
		# begin the attack, adding the visual
		battle.start_chem_attack()
		
		# wait for the visual that the chemical spawned after pouring
		yield(get_tree().get_nodes_in_group("chem_visual")[0], "chem_visual_completed")
		# filled guy slide away
		$AnimationPlayer.play("fillingflask slide out")
		yield($AnimationPlayer, "animation_finished")
		get_parent().chem_anim_complete() # end our turn
		
	
	elif chemical.category == chemical.OFFENSE:
		$AnimationPlayer.play("slide out")

extends Node2D

const GREEN_POURING = preload("res://Engine/Battle/CharacterSprites/Green/green_pouring.png")
const GREEN_FILLING = preload("res://Engine/Battle/CharacterSprites/Green/green_flask.png")
const GREEN_MASK = preload("res://Engine/Battle/CharacterSprites/Green/green_flask_mask.png")
const ORANGE_POURING = preload("res://Engine/Battle/CharacterSprites/Orange/orange_pouring.png")
const ORANGE_FILLING = preload("res://Engine/Battle/CharacterSprites/Orange/orange_flask.png")
const ORANGE_MASK = preload("res://Engine/Battle/CharacterSprites/Orange/orange_flask_mask.png")

onready var battle = get_node("..")
onready var liq_pour = get_node("PouringFlask/LiquidPouring")
onready var liq = get_node("FillingFlask/LiquidFilled")

var fill_perc = 0.0
var stopped = false

var output_effectiveness = 0
var done_sliding = false

var firt = false
var overflowed = false
var success = false

var chemical

enum chem_appearance_type { MATERIAL, COLOR }

func _ready():
	visible = false
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finish")
	liq.value = 0
	$PouringFlask/AnimationPlayer.play("stop_pouring")
	

func _process(delta):
	if battle.state == battle.POURING:
		if not firt:
			firt = true
			visible = true
			
			chemical = battle.get_node("BattleChoices/Chemicals").get_child(battle.selected_chem)
			update_liq(0)
			# set appearance of the liquid (liquipouring and liquidfilled). material (shader+params) if it has one, color if it doesn't
			liq_pour.set_material(null)
			liq.set_material(null)
			liq_pour.set_material(null)
			liq.set_material(null)
			# var material_or_color
			var chem_appearance
			if chemical.get_node("Liquid").get_material() != null:
				chem_appearance = chemical.get_node("Liquid").get_material()
				print("got the chemical material")
				liq_pour.set_material(chem_appearance)
				liq.set_material(chem_appearance)
			else:
				print("didn't get the chemical material, getting color")
				chem_appearance = chemical.color
				liq_pour.set_modulate(chem_appearance)
				liq.set_modulate(chem_appearance)
			
			set_process(false) # i feel..
			$AnimationPlayer.play("slide in")
			yield($AnimationPlayer, "animation_finished")
			$PouringFlask/AnimationPlayer.play("start_pouring")
			yield($PouringFlask/AnimationPlayer, "animation_finished")
			set_process(true) # ..horrible
		
		if done_sliding:
			
			# 0-100 to 216-96
			# output = output_start + ((output_end - output_start) / (input_end - input_start)) * (input - input_start)
			$FillTarget.position.y = 216.0 + ((96.0 - 216.0) / (100.0 - 0.0)) * (chemical.fill_target - 0.0)
			if not stopped:
				if not $PouringPlayer.playing:
					$PouringPlayer.play()
				else:
					# 0.5 to 1.5
					$PouringPlayer.pitch_scale = fill_perc * 0.01 + 0.5
					
				fill_perc += chemical.fill_speed * 60 * delta
				update_liq(fill_perc)
				
				
				if ( (PlayerStats.player_count == 1) and Input.is_action_just_pressed(battle.player_confirm) ) \
				or ( (PlayerStats.player_count >= 2) and Input.is_action_just_pressed(battle.other_player_confirm) ) \
				or fill_perc >= 100: # or int(fill_perc) == int(chemical.fill_target):
					if fill_perc >= 100:
						overflowed = true
						
					stopped = true
					output_effectiveness = 0
					
					if fill_perc < chemical.fill_target + chemical.fill_tolerance and fill_perc > chemical.fill_target - chemical.fill_tolerance:
						
						var dist_to_target = float(abs(chemical.fill_target - fill_perc)) / float(chemical.fill_target)
						output_effectiveness = chemical.min_effectiveness + (chemical.effectiveness - chemical.min_effectiveness) * (1 - dist_to_target)
						
						# perfect
						if int(fill_perc) == int(chemical.fill_target):
							output_effectiveness = chemical.effectiveness * chemical.perfect_multiplier
							# spawn "spot on!" thingy
							var spot_on_thingy = load("res://Engine/SpotOn/SpotOn.tscn").instance()
							spot_on_thingy.position = Vector2(194, 84)
							get_parent().add_child(spot_on_thingy) # spawn on parent since self gets invisible
							
							
						# pass it around to effects for the effectiveness to be
						# modified by them
						# this could be replaced with a group, i guess.
						for child in $FillingFlask.get_children():
							if child.has_method("modify_pour_effectiveness"):
								output_effectiveness = child.modify_pour_effectiveness(output_effectiveness)
						success = true
						print("REREREREREREReffectiveness info: fill_perc: %s\ndist_to_target: %s | output_effectiveness: %s" % [fill_perc, dist_to_target, output_effectiveness])
					else:
						success = false
						print("fill percentage is intolerable!")
						if overflowed:
							print("...but it overflowed!")
							# 1/8 chance of being very powerful, 7/8 chance of self-harm
							var random_num = randf()
							if random_num < 0.125:
								# powerful
								success = true # sike
								output_effectiveness = 20 # uh could be different
								for child in $FillingFlask.get_children():
									if child.has_method("modify_pour_effectiveness"):
										output_effectiveness = child.modify_pour_effectiveness(output_effectiveness) # 10 indents lol
							else:
								# ouch
								var green_ouch = int(randf()*40)
								
								var big_asplosion = load("res://Engine/Battle/BigChemicalExplosion.tscn").instance()
								big_asplosion.position = Vector2(193, 165)
								battle.add_child(big_asplosion)
								yield(get_tree().create_timer(0.285), "timeout")
								hurt_self(green_ouch, int(green_ouch/1.6))
							
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
		
		if success:
			print("hey the pouring guys should be inbvidible now")
			# just offensive here i think
			battle.start_chem_attack()
		else:
			# welp enemy's turn now since you're BAD
#			battle.state = battle.ENEMY_TURN
			battle.chem_anim_complete()
	
#	elif anim == "pouringflask slide out":
#
	#firt = false
	
func reset():
	visible = false
	$FillTarget.visible = true
	fill_perc = 0.0
	stopped = false

func stop():
	# reset pouring sound
	$PouringPlayer.playing = false
	$PouringPlayer.pitch_scale = 0.5

	# make the liquid "stop coming out"
	$PouringFlask/AnimationPlayer.play("stop_pouring")
	yield($PouringFlask/AnimationPlayer, "animation_finished")

	if chemical.category == chemical.DEFENSE:
		# make the pourer slide away, spawn the effect on the filled, and then \
		#  make the filled guy slide away and then we're done
		$FillTarget.visible = false
		$AnimationPlayer.play("pouringflask slide out")
		# wait for the slide away to finis
		yield($AnimationPlayer, "animation_finished")
		if not success:
			yield(spawn_fail_visual().get_node("AnimationPlayer"), "animation_finished")
			$AnimationPlayer.play("fillingflask slide out")
			yield($AnimationPlayer, "animation_finished")
			battle.chem_anim_complete()
			return
		# begin the attack, adding the visual
		
		battle.start_chem_attack()
		
		# wait for the visual that the chemical spawned after pouring
		yield(get_tree().get_nodes_in_group("chem_visual")[0], "chem_visual_completed")
		# filled guy slide away
		$AnimationPlayer.play("fillingflask slide out")
		yield($AnimationPlayer, "animation_finished")
		get_parent().chem_anim_complete() # end our turn
		
	
	elif chemical.category == chemical.OFFENSE:
		if not success:
			spawn_fail_visual()
			yield(spawn_fail_visual().get_node("AnimationPlayer"), "animation_finished")
			
		$AnimationPlayer.play("slide out")
	
	

func spawn_fail_visual():
	var fail_visual = load("res://Engine/Battle/FailedAttack.tscn").instance()
	fail_visual.position.y = -100
	$FillingFlask.add_child(fail_visual)
	return fail_visual

func hurt_self(num1, num2):
	battle.hurt("green", num1)
	battle.hurt("orange", num2)
	
	
func swap_character_sprites(new = 1): # 1 for green's turn, 2 for orange's
	match new:
		1:
			$FillingFlask.set_texture(GREEN_FILLING)
			$FillingFlask/LiquidFilled.set_progress_texture(GREEN_MASK)
			$PouringFlask/Sprite.set_texture(ORANGE_POURING)
		2:
			$FillingFlask.set_texture(ORANGE_FILLING)
			$FillingFlask/LiquidFilled.set_progress_texture(ORANGE_MASK)
			$PouringFlask/Sprite.set_texture(GREEN_POURING)

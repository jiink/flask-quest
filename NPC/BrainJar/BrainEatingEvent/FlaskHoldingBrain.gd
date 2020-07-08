extends Sprite

enum {GREEN, ORANGE}

export(int, "GREEN", "ORANGE") var who = GREEN 

var ready = true 
var eating_progress = 0.0 # goes from 0 to 1
const CHEW_AMOUNT = 0.02 # how much the eating progress goes up on each chew
var done = false
var eat_button = "confirm"
enum {SMALL, LARGE}

signal finished_eating

onready var floaty_text = preload("res://Engine/FloatyText.tscn")
const FLOATY_TEXT_STRING = "IQ increased by 1!"


func _ready():
	if (PlayerStats.player_count > 1) and (who == ORANGE):
		eat_button += "2"
	$HalfBrain/Particles2D/Timer.connect("timeout", self, "_on_particles_impulse_timeout")
	$HalfBrain.set_animation("default")


func _input(event):
	if ready and not done:
		if event.is_action_pressed(eat_button):
			eat()


func eat():
	eating_progress += CHEW_AMOUNT
	if eating_progress >= 1.0:
		finish_eating()
	elif eating_progress > 0.6:
		$HalfBrain.set_animation("small") # make brain look smaller
	
	$AnimationPlayer.play("chomp")
	$AudioStreamPlayer2D.pitch_scale = randf() * 0.3 + 0.75
	$AudioStreamPlayer2D.playing = true
	emit_particles()
	var floaty_text_instance = floaty_text.instance()
	add_child(floaty_text_instance)
	if who == GREEN:
		floaty_text_instance.position = Vector2(60, -20)
	else:
		floaty_text_instance.position = Vector2(-60, -20)
	floaty_text_instance.set_text(FLOATY_TEXT_STRING)

	
func finish_eating():
	emit_signal("finished_eating")
	done = true
	$HalfBrain.visible = false


func emit_particles():
	$HalfBrain/Particles2D.emitting = true
	$HalfBrain/Particles2D/Timer.start()

	
func _on_particles_impulse_timeout():
	$HalfBrain/Particles2D.emitting = false

extends Node2D

signal hit_foe
signal anim_complete

var frame = 0

export(int) var hitframe = 1
export(float) var anim_speed

var t = 1
var done = false
var already_hit = false
onready var sprite = get_node("BaseChemicalAnim")

func _ready():
	connect("hit_foe", get_node(".."), "chem_hit_foe")
	connect("anim_complete", get_node(".."), "chem_anim_complete")

func _process(delta):
	if not done:
		
		if t < sprite.hframes:
			sprite.frame = t
			
			if sprite.frame == hitframe and not already_hit:
				emit_signal("hit_foe")
				already_hit = true
		else:
			emit_signal("anim_complete")
			t = 0
			done = true
			visible = false
		t += anim_speed
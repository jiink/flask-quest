extends Node2D

export(String) var words = "ok"
onready var timer = $BadWordTimer

var badword_pool = ["simpleton", "neanderthal", "nincompoop", "moron", "brainlet", "idiot", "fool", "nitwit", "greenvillager", "twit", "twat", "cretin", "bonehead", "blockhead", "imbecile", "ignoramus", "dunce", "pinhead", "ninny"]
var badword

func _ready():
#	timer.text = words
	badword = badword_pool[0]

func _process(delta):
	# '%' to make bad word 
	$Label.text = words.replace('%', badword)
	pass

func _on_BadWordTimer_timeout():
	badword = badword_pool[rand_range(0, badword_pool.size()-1)]
	timer.wait_time *= 1.15

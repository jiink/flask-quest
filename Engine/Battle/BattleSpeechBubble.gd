extends Label

onready var words = text
onready var timer = $BadWordTimer

var badword_pool = ["simpleton", "neanderthal", "nincompoop", "moron", "brainlet", "idiot", "fool", "nitwit", "greenvillager", "twit", "twat", "cretin", "bonehead", "blockhead", "imbecile", "ignoramus", "dunce", "pinhead", "ninny", "bozo"]
var badword

func _ready():
#	timer.text = words
	badword = badword_pool[0]

func _process(delta):
	# put '*' in the textbox to make bad word 
	text = words.replace('*', badword)

func _on_BadWordTimer_timeout():
	badword = badword_pool[rand_range(0, badword_pool.size()-1)]
	timer.wait_time *= 1.15

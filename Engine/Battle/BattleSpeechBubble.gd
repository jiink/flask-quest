extends Label

onready var words = text
onready var timer = $BadWordTimer

var badword_pool = ["simpleton", "neanderthal", "nincompoop", "moron", "brainlet", "idiot", "fool", "nitwit", "greenvillager", "twit", "twat", "cretin", "bonehead", "blockhead", "imbecile", "ignoramus", "dunce", "pinhead", "ninny", "bozo"]
var badword
onready var base_pos = rect_position
var t = 0

func _ready():
	badword = badword_pool[0]
	text = words.replace('*', badword)

func _process(delta):
	t += 1
	if t % 3 == 0:
		rect_position = Vector2(base_pos.x + sin(t*.04)*2.0, base_pos.y + cos(t*.04+3)*2.0)


func _on_BadWordTimer_timeout():
	badword = badword_pool[rand_range(0, badword_pool.size()-1)]
#	timer.wait_time *= 1.15
	# put '*' in the textbox to make bad word 
	text = words.replace('*', badword)
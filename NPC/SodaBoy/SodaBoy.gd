extends AnimatedSprite

onready var soda_collection = get_tree().get_current_scene().get_node("SodaCollection")
onready var tween = $Tween

enum {
	ALIVE,
	TRANSITION,
	DEAD
}

var state = ALIVE

func _init():
	playing = true
	
func interact():
	match state:
		ALIVE:
			if soda_collection.remaining_sodas == soda_collection.total_sodas:
				DiagHelper.start_talk(self, "BeforeCollecting")
			elif soda_collection.remaining_sodas <= 0:
				DiagHelper.start_talk(self, "NoMore")
			elif soda_collection.remaining_sodas < soda_collection.total_sodas:
				DiagHelper.start_talk(self, "AfterCollecting")
		TRANSITION:
			pass
		DEAD:
			DiagHelper.start_talk(self, "Dead")

# Called by dialogue.
# Switch animations and tween position to roll down the screen and off it
func roll_out():
	animation = "roll"
	tween.interpolate_property(self, "position:y", null, position.y + 216, 3.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	# stop animating
	state = DEAD
	playing = false
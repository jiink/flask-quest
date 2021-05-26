extends "res://Rooms/TemplateRoom.gd"

const SAVE_KEY = "8-2_"

enum StoryState {
	INITIAL,
	PRE_TEACH,
	POST_TEACH,
	SUCCULENT_ACCESS
}

var current_story_state = StoryState.INITIAL

onready var guard_event = $GuardEvent
onready var teach_event = $TeachEvent
onready var train = $Train

func save(save_game):
	save_game.data[SAVE_KEY + "story_state"] = current_story_state

func load(save_game):
	current_story_state = save_game.data[SAVE_KEY + "story_state"]
	
	guard_event = $GuardEvent
	teach_event = $TeachEvent
	train = $Train
	
	setup()
	
	
func setup():
	match current_story_state:
		StoryState.INITIAL:
			event_setup(false, false, false)
			train.activate()
			
		StoryState.PRE_TEACH:
			event_setup(true, true, true)
			train.activate()
			
		StoryState.POST_TEACH:
			event_setup(true, true, false)
			train.activate()
			
		StoryState.SUCCULENT_ACCESS:
			event_setup(true, false, false)
			

func event_setup(guard_activated, guard_waiting, teach_waiting):
	guard_event.activated = guard_activated
	guard_event.waiting_for_cert = guard_waiting
	teach_event.waiting = teach_waiting

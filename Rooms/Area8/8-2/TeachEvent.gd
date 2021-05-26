extends Node2D

var waiting = false

onready var root = get_tree().get_current_scene()


func _ready():
	$EventArea.connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body):
	if body == global.get_player(1) and waiting:
		waiting = false
		DiagHelper.start_talk(self, "Comment")
		
func give_cert():
	ItemManager.give_item("teaching_cert")
	root.current_story_state = root.StoryState.POST_TEACH

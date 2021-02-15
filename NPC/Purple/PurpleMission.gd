extends KinematicBody2D

const SAVE_KEY = "6-1_"

var scene_root
var time_of_day
var current_story_state

var interactable = true

var pitch

func save(save_game):
	save_game.data[SAVE_KEY + "time_of_day"] = time_of_day
	save_game.data[SAVE_KEY + "story_state"] = current_story_state

func load(save_game):
	time_of_day = save_game.data[SAVE_KEY + "time_of_day"]
	current_story_state = save_game.data[SAVE_KEY + "story_state"]

func interact():
	scene_root = get_tree().get_current_scene()
	if interactable:
		if scene_root.name == "6-1":
			DiagHelper.start_talk(self, "LeadIntoHome")
			scene_root.current_story_state = 8
		elif scene_root.name == "6-7":
			print(scene_root.name)
			print(current_story_state)
			match current_story_state:
				8:
					print("I'm dialogging like it's 8 in 6-7!!!!")
					DiagHelper.start_talk(self, "Letters")
				9:
					DiagHelper.start_talk(self, "LettersReminder")

func enter_house():
	$Tween.interpolate_property(self, "position",
	null, position + Vector2(0, -6), 0.2, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()


func give_letters():
	current_story_state = 9
	scene_root.current_story_state = 9
	for i in range(5):
		pitch = 1 + (i * 0.1)
		ItemManager.give_item("purple_letter")
		$ItemSFX.pitch_scale = pitch
		$ItemSFX.play()
		yield(get_tree().create_timer(0.4), "timeout")

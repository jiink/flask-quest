extends StaticBody2D

enum MailBox { ONE, TWO, THREE, FIVE, SIX }
export(MailBox) var mailbox_number

var opened = false
export(AudioStream) var sound_name
#export(bool) var do_diag = false

onready var scene_root = get_tree().get_current_scene()

func interact():
	if scene_root.current_story_state == scene_root.StoryState.PURPLE_LETTERS_REMINDER:
		if opened == false and ItemManager.has_item("purple_letter"):
			DiagHelper.start_talk(self, "Use")
			ItemManager.toss_item("purple_letter", 0, true)
			opened = true
			if scene_root.name == "6-1":
				scene_root.mail_boxes[mailbox_number] = true
				print(opened)
				print(scene_root.mail_boxes[mailbox_number])
		else:
			DiagHelper.start_talk(self, "AlreadyUsed")
	else:
		print("WHAT? IT'S %s, NOT 9" % scene_root.current_story_state)

extends Sprite

onready var green = global.get_player(1)
onready var orange = global.get_player(2)
onready var ribbit = global.get_player(3)
onready var animator = $AnimationPlayer
onready var murk_monster = get_tree().get_current_scene().get_node("MurkMonster")
var interactable = true
var state = 0 #Which part of the story are you in?

const MM_INTRO_SCENE = \
preload("res://Cutscenes/MurkMonsterSequence/MMIntroductionSequence/MMIntroductionSequence.tscn")

const SAVE_KEY = "6-1_"

var requested_poppy_dog 

func save(save_game):
	save_game.data[SAVE_KEY + "poppy_dog_requested"] = requested_poppy_dog

func load(save_game):
	requested_poppy_dog = save_game.data[SAVE_KEY + "poppy_dog_requested"]

func change_stand_sprite(new_frame):
	frame = new_frame



func interact():
	if interactable:
		if state < 2:
			DiagHelper.start_talk(self, "PreMM")
		elif state == 2: # During the Murk Monster session
			if requested_poppy_dog:
				if ItemManager.has_item("poppy_dog"):
					DiagHelper.start_talk(self, "HasItem")
					ItemManager.toss_item("poppy_dog", ItemManager.ANY, true)
				else:
					DiagHelper.start_talk(self, "NoItem")
			else:
				DiagHelper.start_talk(self, "Event")

		elif (state > 2): # later, add separate dialogue for each part of the story
			DiagHelper.start_talk(self, "Post")
		else:
			pass

func look_for_sneaky_boys(): # did the player ALREADY get the poppy dog?
	if ItemManager.has_item("poppy_dog"):
		interactable = false
		yield(get_tree().create_timer(0.1), "timeout")
		interactable = true
		DiagHelper.start_talk(self, "PreAcquired")
	else:
		requested_poppy_dog = true

func accept():
	interactable = false
	animator.play("enter_boat")

	var original_orange_controller = orange.controlled_by
	
	green.controlled_by = green.EXTERNAL
	orange.controlled_by = orange.EXTERNAL
	ribbit.controlled_by = ribbit.EXTERNAL
	
	$Tween.interpolate_property(green, "position",
	null, Vector2(1243, -866), 1.8, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(orange, "position",
	null, Vector2(1218, -864), 2.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(ribbit, "position",
	null, Vector2(1232, -853), 2.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	
	yield(animator,"animation_finished")
	DiagHelper.start_talk(self, "BoatPreMonster")

func take_poppy_dog():
	ItemManager.toss_item("poppy_dog", 1, true)


func take_money():
	if PlayerStats.dollars >= 4:
		PlayerStats.dollars = PlayerStats.dollars - 4
		interactable = false
		yield(get_tree().create_timer(0.1), "timeout")
		interactable = true
		DiagHelper.start_talk(self, "UseMoney")
	else:
		interactable = false
		yield(get_tree().create_timer(0.1), "timeout")
		interactable = true
		DiagHelper.start_talk(self, "Poor")
#	global.start_scene_switch("res://Cutscenes/MurkMonsterSequence/MurkMonsterSequence.tscn", \
#	Vector2(0,0))

func cutscene_a():
	var mm_intro = MM_INTRO_SCENE.instance()
	get_tree().get_current_scene().get_node("HUD").add_child(mm_intro)
	var mm_intro_animator = get_tree().get_current_scene().get_node("HUD/MMIntroductionSequence/AnimationPlayer")
	yield(mm_intro_animator, "animation_finished")
	murk_monster.visible = true
	murk_monster.flip_h = true
	mm_intro.queue_free()
	yield(get_tree().create_timer(1), "timeout")
	DiagHelper.start_talk(self, "BoatMonster")

func mm_submerge():
	animator.play("mm_submerge")
	yield(animator, "animation_finished")
	DiagHelper.start_talk(self, "BoatMonsterSubmerge")

func mm_remerge():
	animator.play("mm_remerge")
	yield(animator, "animation_finished")
	DiagHelper.start_talk(self, "BoatMonsterRemerge")

func mm_elevate():
	yield(get_tree().create_timer(1), "timeout")
	animator.play("mm_elevate")
	yield(get_tree().create_timer(1), "timeout")
	DiagHelper.start_talk(self, "BoatMonsterElevate")
	
func enter_cutscene():
	global.start_scene_switch("res://Cutscenes/MurkMonsterSequence/MurkMonsterSequence.tscn",
	Vector2(0,0))
	global.swap_scenes()

extends "res://Rooms/TemplateRoom.gd"

const CHAPTER_INTRO_SCENE = preload("res://Cutscenes/ChapterIntro/ChapterIntro.tscn")

func _on_StartTimer_timeout():
	DiagHelper.start_talk(self)
	
func start_stage_1():
	$SleepStages.play("sleep_stage_1")
	
func start_stage_2():
	$SleepStages.play("sleep_stage_2")
	
func start_stage_3():
	$SleepStages.play("sleep_stage_3")
	yield(get_tree().create_timer(4), "timeout")
	MusicManager.change_music("res://Engine/zzzzzz.ogg", true, 4)
	yield(get_tree().create_timer(2), "timeout")
	var chapter_intro = CHAPTER_INTRO_SCENE.instance()
	global.get_hud().add_child(chapter_intro)
	chapter_intro.change_chapter(chapter_intro.Chapters.CH3)
	chapter_intro.new_scene = "res://Rooms/Area5/5-1/5-1.tscn"
	chapter_intro.starting_direction = chapter_intro.StartingDirection.DOWN
	chapter_intro.player_new_position = Vector2(3268,487)
#	chapter_intro.position = camera.position - Vector2(384/2, 216/2) + camera.offset

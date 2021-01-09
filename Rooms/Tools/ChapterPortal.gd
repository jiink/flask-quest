extends Node2D

enum StartingDirection { NONE, UP, RIGHTUP, RIGHT, RIGHTDOWN, DOWN, LEFTDOWN, LEFT, LEFTUP }

export (String, FILE, "*.tscn") var new_scene = ""
export (Vector2) var player_new_position = null
export(StartingDirection) var starting_direction = StartingDirection.NONE

const CHAPTER_INTRO_SCENE = preload("res://Cutscenes/ChapterIntro/ChapterIntro.tscn")

enum Chapters {
	NONE,
	CH1,
	CH2,
	CH3,
	CH4,
	CH5,
	CH6,
	CH7,
	EPILOGUE
}

export(Chapters) var chapter = Chapters.NONE
var transitioning

func _ready():
	connect("body_entered", self, "on_body_entered")
	
func on_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player"):
		
		if new_scene != "" and not transitioning:
			#get_tree().change_scene(new_scene)
			transitioning = true
			MusicManager.change_music("res://Engine/zzzzzz.ogg", true, 1)
			var chapter_intro = CHAPTER_INTRO_SCENE.instance()
			global.get_hud().add_child(chapter_intro)
			chapter_intro.change_chapter(chapter)
			chapter_intro.new_scene = new_scene
			chapter_intro.starting_direction = starting_direction
			chapter_intro.player_new_position = player_new_position
#			chapter_intro.position = camera.position - Vector2(384/2, 216/2) + camera.offset
			global.freeze_all_players()
			
		else:
			print("error: new_scene empty")

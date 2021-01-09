extends Node2D

enum StartingDirection { NONE, UP, RIGHTUP, RIGHT, RIGHTDOWN, DOWN, LEFTDOWN, LEFT, LEFTUP }

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

export(Chapters) var chapter
export(String, FILE, "*.tscn") var new_scene = ""
export (Vector2) var player_new_position
export(StartingDirection) var starting_direction = StartingDirection.NONE


onready var chapter_sprite = $ChapterSprite
onready var audio = $AudioStreamPlayer

func change_chapter(new_chapter):
	chapter = new_chapter
	chapter_sprite.frame = chapter
	var speed_scale = chapter * 0.05 + 0.95
	audio.pitch_scale = speed_scale
	$AnimationPlayer.playback_speed = speed_scale
	

func _on_AnimationPlayer_animation_finished(anim_name):
	global.start_scene_switch(new_scene, player_new_position, starting_direction)
	global.swap_scenes()

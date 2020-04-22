extends Sprite

var sound = "res://Engine/SpotOn/spot_on.ogg" # default
var scene_identifier 

# different sounds for different areas
var area_to_sound = {
	"3-" : "res://Engine/SpotOn/spot_on_sewer.ogg",
	"5-" : "res://Engine/SpotOn/spot_on_glasstown.ogg"
}

func _ready():
	
	# sound
	scene_identifier = get_tree().get_current_scene().name.left(2) # first two letters
	if area_to_sound.get(scene_identifier):
		sound = area_to_sound.get(scene_identifier)
	var sound_player = AudioStreamPlayer.new()
	sound_player.stream = load(sound) # set correct sound
	get_parent().add_child(sound_player) # give it to parent so it doesn't despawn with self
	sound_player.play()
	
	# visuals
	$Particles2D.emitting = true
	
	$Tween.interpolate_property(self, "scale",
			null, Vector2(2, 2),
			0.8, Tween.TRANS_SINE, Tween.EASE_IN)
	
	$Tween.interpolate_property(self, "modulate:a",
			null, 0,
			0.8, Tween.TRANS_SINE, Tween.EASE_IN)
	
	$Tween.start()
	

func _on_Tween_tween_all_completed():
	queue_free()

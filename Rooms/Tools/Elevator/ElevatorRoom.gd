extends Node2D

export(String) var direction = "down"
export (String, FILE, "*.tscn") var new_scene = ""
export (Vector2) var player_new_position = null

func _ready():
	$ScenePortal.new_scene = new_scene
	$ScenePortal.player_new_position = player_new_position

func _on_TriggerField_body_entered(body):
	if body == get_tree().get_nodes_in_group("Player")[0]:
		$AnimationPlayer.play("go_%s" % direction)
		$FloorIndicator.set_process(true)

func _on_AnimationPlayer_animation_finished(anim):
	$FloorIndicator.set_process(false)

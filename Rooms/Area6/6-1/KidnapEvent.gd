extends Node2D

onready var scene_camera = get_tree().get_current_scene().get_node("Camera")
onready var player = get_tree().get_current_scene().get_node("YSort/Player")
onready var scene_root = get_tree().get_current_scene()
	
const BEARLY_BEARABLE_BEAR_SCENE = preload("res://NPC/BearlyBearableBear/BearlyBearableBear.tscn")

func _on_KidnapZone_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player"):
		body.frozen = true
		$"KidnapZone/CollisionShape2D".set_deferred("disabled", true)
		scene_camera.follow_player = false
		
		####Camera tween
		yield(get_tree().create_timer(0.5), "timeout")
		$Tween.interpolate_property(scene_camera, "position",
			null, Vector2(537, -452),
			20, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		$Tween.start()
		####
		
		DiagHelper.start_talk(self)

func bear_appear():
	var bearly_bearable_bear = BEARLY_BEARABLE_BEAR_SCENE.instance()
	get_parent().get_node("YSort").add_child(bearly_bearable_bear)
	bearly_bearable_bear.position = player.position + Vector2(0,128)
	bearly_bearable_bear.facing_direction = bearly_bearable_bear.Direction.UP
	####Bear tween
	$CharTween.interpolate_property(bearly_bearable_bear, "position",
		(player.position + Vector2(0,128)), (player.position + Vector2(0,32)),
		0.5, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	$CharTween.start()
	###
	
	MusicManager.change_music(null, true, 0.2)
	$AlertNoise.play()
	
	####Camera tween
	$Tween.stop_all()
	$Tween.interpolate_property(scene_camera, "position",
		null, player.position,
		0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
	####

#Sends the player to 6-2
func kidnap():
	var black_rect = $BlackRect
	black_rect.visible = true
	yield(get_tree().create_timer(0.5), "timeout")
	$HitNoise.play()
	$BreakNoise.play()
	
	scene_root.pre_kidnap_events_occured = true
	
	yield(get_tree().create_timer(3), "timeout")
	global.start_scene_switch("res://Rooms/Area6/6-2/6-2.tscn", Vector2(169,123))
	global.swap_scenes()

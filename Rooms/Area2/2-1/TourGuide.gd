extends KinematicBody2D

onready var path_movement = $PathMovement
onready var green = global.get_player(1)
onready var orange = global.get_player(2)
onready var camera = get_tree().get_current_scene().get_node("Camera")
var original_camera_pos

var interactable = true

func interact():
	if interactable:
		DiagHelper.start_talk(self, "Intro")

func goto_coast():
	camera_follow_player()
	$CollisionShape2D.set_deferred("disabled", true)
	green.visible = false
	orange.visible = false
	interactable = false
	$RemoteTransform2D.update_position = true
	path_movement.play("goto_coast")
	yield(path_movement, "animation_finished")
	
	original_camera_pos = camera.position
	camera.follow_player = false
	$Tween.interpolate_property(camera, "position", \
		null, Vector2(-500, 0), 0.7, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	DiagHelper.start_talk(self, "PresentCoast")

func goto_park():
	camera_follow_player()
	path_movement.play("goto_park")
	yield(path_movement, "animation_finished")
	
	camera.follow_player = false
	$Tween.interpolate_property(camera, "position", \
		null, Vector2(1650, -125), 0.7, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	DiagHelper.start_talk(self, "PresentPark")
	
func goto_cat():
	camera_follow_player()
	path_movement.play("goto_cat")
	yield(path_movement, "animation_finished")
	var cat = get_node_or_null("../NPC/MalusHinterWalking")
	if cat:
		DiagHelper.start_talk(self, "PresentCat")
	else:
		DiagHelper.start_talk(self, "MissingCat")
		
func goto_restaurant():
	path_movement.play("goto_restaurant")
	yield(path_movement, "animation_finished")
	
	camera.follow_player = false
	$Tween.interpolate_property(camera, "position", \
		null, Vector2(1600, -650), 0.7, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	DiagHelper.start_talk(self, "PresentRestaurant")
	
func goto_return():
	camera_follow_player()
	path_movement.play("return")
	yield(path_movement, "animation_finished")
	DiagHelper.start_talk(self, "Final")
	
func release_players():
	$CollisionShape2D.set_deferred("disabled", false)
	green.visible = true
	orange.visible = true
	orange.clear_history()
	interactable = true

func camera_follow_player():
	$Tween.interpolate_property(camera, "position", \
		null, green.position, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	camera.follow_player = true
	
func move_camera(pos, time):
	camera.follow_player = false
	$Tween.interpolate_property(camera, "position", \
		null, pos, time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()

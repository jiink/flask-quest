extends Node2D

onready var green = global.get_player(1)
onready var orange = global.get_player(2)
onready var ribbit = global.get_player(3)
onready var bat_a = get_tree().get_current_scene().get_node("YSort/NPCs/BatGuardA")
onready var bat_b = get_tree().get_current_scene().get_node("YSort/NPCs/BatGuardB")

onready var animator = $CharacterMover
onready var tween = $Tween
onready var camera = global.get_camera()
onready var succulent_portal_col = get_tree().get_current_scene().get_node("PosPortals/SuccPortal/CollisionShape2D")
onready var root = get_tree().get_current_scene()

var activated = false
var waiting_for_cert = false


func _ready():
	$EventActivation.connect("body_entered", self, "_on_EventActivation_body_entered")
	
	
func _on_EventActivation_body_entered(body):
	if body.is_in_group("Player") and (not activated):
			activated = true
			succulent_portal_col.set_deferred("disabled", true)
			green.controlled_by = green.EXTERNAL
			orange.controlled_by = orange.EXTERNAL
			ribbit.controlled_by = ribbit.EXTERNAL
			camera.follow_player = false
			DiagHelper.start_talk(self, "Initial")
			
			
	if body == global.get_player(1) and waiting_for_cert:
		if ItemManager.has_item("teaching_cert"):
			DiagHelper.start_talk(self, "HasCert")
			$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
			waiting_for_cert = false
			root.current_story_state = root.StoryState.SUCCULENT_ACCESS
			get_tree().get_current_scene().get_node("Train").reset()
			
		else:
			DiagHelper.start_talk(self, "NoCert")
		
		
func surround():
	animator.play("surround_player")
	tween.interpolate_property(camera, "position", null, Vector2(1120, 996), 0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.interpolate_property(green, "position", null, Vector2(1128, 993), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(orange, "position", null, Vector2(1119, 1002), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(ribbit, "position", null, Vector2(1134, 1000), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	DiagHelper.start_talk(self, "Surrounded")


func anim_then_diag(anim_name, diag_name):
	animator.play(anim_name)
	yield(animator, "animation_finished")
	DiagHelper.start_talk(self, diag_name)
	
	
func release_players():
	camera.follow_player = true
	succulent_portal_col.set_deferred("disabled", false)
	green.controlled_by = green.PERSON
	ribbit.controlled_by = ribbit.BOT
	if PlayerStats.player_count > 1: 
		orange.controlled_by = orange.PERSON
	else:
		orange.controlled_by = orange.BOT
	green.clear_history()
	
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
	waiting_for_cert = true
	
	get_tree().get_current_scene().get_node("TeachEvent").waiting = true
	
	root.current_story_state = root.StoryState.PRE_TEACH


extends "res://Rooms/TemplateRoom.gd"

onready var main_animator = get_node("MainAnimator")
onready var orange_bound = get_node("YSort/OrangeBound")
onready var green_bound = get_node("YSort/GreenBound")
onready var ribbit_bound = get_node("YSort/RibbitBound")
onready var orange_player = global.get_player(1)
onready var green_player = global.get_player(2)
onready var ribbit_player = global.get_player(3)

var captured_music = preload("res://Rooms/Area6/Assets/captured_by_the_bearly_bearable_bear.ogg")

func _ready():
	global.connect("battle_won", self, "on_battle_won")
	yield(get_tree().create_timer(1.5), "timeout")
	DiagHelper.start_talk(self, "Initial")
	$ExitPortal/CollisionShape2D.set_deferred("disabled", true)

func bear_enter_room():
	main_animator.play("bear_enter")
	yield(get_tree().create_timer(2), "timeout")
	DiagHelper.start_talk(self, "BearInitial")
	
func bear_reposition():
	main_animator.play("bear_reposition")
	yield(get_tree().create_timer(3), "timeout")
	DiagHelper.start_talk(self, "BearIntro")
	MusicManager.change_music(captured_music, true, 0.1)

func ribbit_enter_room():
	MusicManager.change_music(null, true, 0)
	main_animator.play("ribbit_enter_room")
	yield(get_tree().create_timer(5), "timeout")
	DiagHelper.start_talk(self, "RibbitIntro")
	
func ribbit_beat_up():
	main_animator.play("ribbit_beat_up")
	yield(get_tree().create_timer(5), "timeout")
	DiagHelper.start_talk(self, "BearLeave")
	MusicManager.change_music(captured_music, true, 0)
func bear_leave_room():
	main_animator.play("bear_leave_room")
	yield(get_tree().create_timer(1.5), "timeout")
	DiagHelper.start_talk(self, "RibbitDiscussion")
	
func bear_return():
	MusicManager.change_music(null, true, 0)
	$AlertAudio.playing = true
	main_animator.play("bear_return")
	yield(get_tree().create_timer(1.5), "timeout")
	DiagHelper.start_talk(self, "BearReturn")
	
func bear_fight():
	global.start_battle(["BearlyBearableBear"])
	
func on_battle_won():
	$"OverlayRect".visible = false
	DiagHelper.start_talk(self, "PostBear")
	orange_bound.visible = false
	green_bound.visible = false
	ribbit_bound.visible = false
	green_player.clear_history()
	green_player.position = Vector2(169,123)
	orange_player.position = Vector2(210,122)
	green_player.visible = true
	orange_player.visible = true
	ribbit_player.visible = true
	$"YSort/BearlyBearableBear".position = Vector2(168,209)
	$"PlayerBound".queue_free()
	$ExitPortal/CollisionShape2D.set_deferred("disabled", false)
	ribbit_player.controlled_by = ribbit_player.BOT

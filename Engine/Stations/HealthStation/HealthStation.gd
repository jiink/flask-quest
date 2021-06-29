extends Sprite

var health_menu = load("res://Engine/Stations/HealthStation/HealthMenu.tscn")
var used_before = true
onready var animator = $AnimationPlayer

func save(save_game):
	save_game.data["health_station_used_before"] = used_before

func load(save_game):
	used_before = save_game.data["health_station_used_before"]

func interact():
	if not used_before:
		used_before = true
		var health_menu_instance = health_menu.instance()
		get_owner().get_node("HUD").add_child(health_menu_instance)
		
		yield(health_menu_instance.anim_player, "animation_finished")
		
		heal()
		
	else:
		heal()
		
		
func heal():
	animator.play("heal")
	global.get_player(1).visible = false
	global.get_player(1).frozen = true
	yield(animator, "animation_finished")
	animator.play("idle")
	global.get_player(1).frozen = false
	global.get_player(1).visible = true
	PlayerStats.green_hp = PlayerStats.green_max_hp
	global.get_player().do_floaty_text("Health restored!")
	$ApprovalNoise.play()

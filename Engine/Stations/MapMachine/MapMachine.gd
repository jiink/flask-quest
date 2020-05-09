extends Sprite

signal map_machine_opened

var map_scene

func interact():
#	if ItemManager.inventory.find("map_login") >= 0:
	
	map_scene = load("res://Engine/Stations/MapMachine/MapDisplay.tscn")
	map_scene = map_scene.instance()
	get_owner().get_node("HUD").add_child(map_scene)
	
	if ("map_login" in ItemManager.inventory):
		emit_signal("map_machine_opened")
#	else:
#		DiagHelper.start_talk(self)
	

func _ready():
	$OnArea.connect("body_entered", self, "on_body_entered")
	$OnArea.connect("body_exited", self, "on_body_exited")
	
	frame = 0
	
func on_body_entered(body):
	if body == global.get_player():
		$AnimationPlayer.play("turn_on")

func on_body_exited(body):
	if body == global.get_player():
		$AnimationPlayer.play("turn_off")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "turn_on":
		$AnimationPlayer.play("running")

func freeze_player_again():
	global.get_player().frozen = true

func cancelled():
	map_scene.get_node("AnimationPlayer").play("turn_off")

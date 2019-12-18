extends Node

var has_been_said = false

func _ready():
	if global.get_battle_scene(): global.get_battle_scene().connect("open_chems", self, "on_chems_open")
	$DestroyReminder.visible = false;
	$DestroyReminder/AnimationPlayer.set_speed_scale(0.2);

func on_chems_open():
	print("THE CHEMS HAVE BEEN OPENED!!!!!!!!!!!!!")
	if not has_been_said:
		has_been_said = true
		$DestroyReminder.visible = true;
		$DestroyReminder/AnimationPlayer.play("default");
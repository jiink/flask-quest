extends Node2D

func _ready():
	$SpinGrubly.seek(randf()*3.0)


func _on_wing2_successful_hit(player_num, dmg):
	check_if_should_fly_away()


func _on_wing1_successful_hit(player_num, dmg):
	check_if_should_fly_away()
	
	
func check_if_should_fly_away():
	yield(get_tree().create_timer(0.1), "timeout")
	if not ($"Grubly/body".has_node("wing1") or $"Grubly/body".has_node("wing2")):
		$ComeIn.play_backwards("ComeIn");

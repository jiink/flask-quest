extends Area2D

onready var green = global.get_player(1)
onready var orange = global.get_player(2)
onready var ribbit = global.get_player(3)

var activated = false

func _ready():
	self.connect("body_entered", self, "_body_entered")

func _body_entered(body):
	if ((body == global.get_player(1)) or \
	(PlayerStats.player_count > 1 and body in get_tree().get_nodes_in_group("Player"))) \
	and (not activated):	
		$malus_trainar_hole.visible = true
		$AudioStreamPlayer.play()
		MusicManager.change_music(null, true, 0)
		
		green.frozen = true
		orange.controlled_by = orange.EXTERNAL
		ribbit.controlled_by = ribbit.EXTERNAL
		
		for b in get_tree().get_nodes_in_group("Player"):
			$Tween.interpolate_property(b, "position",
			null, b.position + Vector2(0,6), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
			$Tween.start()
			
		yield($Tween, "tween_all_completed")
		
		var i = 2
		
		for b in get_tree().get_nodes_in_group("Player"):
			
			b.position = $Position2D.position + Vector2(0, -32) + position + Vector2(i * -32, 0)
			
			$Tween.interpolate_property(b, "position",
			null, b.position + Vector2(0, 32), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start()
			i = i - 1
			
			
		yield($Tween, "tween_all_completed")
		
		yield(get_tree().create_timer(1), "timeout")
		green.clear_history()
		green.frozen = false
		ribbit.controlled_by = ribbit.BOT
		
		if PlayerStats.player_count > 1:
			orange.controlled_by = orange.PERSON
		else:
			orange.controlled_by = orange.BOT

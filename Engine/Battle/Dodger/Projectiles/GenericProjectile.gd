extends Area2D

export(bool) var face_center = false
export(NodePath) var face_node = null
enum {NORMAL, GREEN, ORANGE}
export(int, "NORMAL", "GREEN", "ORANGE") var type
export(int) var damage = 15
export(float) var damage_randomness = 0.1
export(bool) var destructable = true

signal successful_hit(player_num, dmg)

var player_inside = 0 # 0 for none, 1 for P1, 2 for P2

export(float) var death_time = 10.0

var death_timer

func _ready():
	var connect_to
	if (get_tree().get_current_scene().name == "AttackTestingField") or (get_tree().get_current_scene().name == "BigAttackTestingField"):
		connect_to = get_tree().get_current_scene()
	else:
		connect_to = get_tree().get_current_scene().get_node_or_null("BattleScene/DodgerField")
	if connect_to:
		print("connect_to's name: %s" % connect_to.name)
		connect("successful_hit", connect_to, "hazard_has_hit")
#	connect("successful_hit", connect_to, "hurt")
	
	connect("area_entered", self, "area_entered")

	
	if not destructable: # if the this hazard is not destructable, it'll deal damage per-tick
		add_to_group("tick")
		connect("area_exited", self, "area_exited") # also use area_exited to keep track of players inside the hazard zone
	
	if face_center:
		look_at(Vector2(192, 108))
		if (get_tree().get_current_scene().name == "AttackTestingField") or (get_tree().get_current_scene().name == "BigAttackTestingField"):
			look_at(Vector2(192*2, 108*2))

	elif face_node != null and face_node != "":
		look_at(get_node(face_node).position)
	if face_center and (face_node != null):
		print("Warning: Can't face two places at once; facing center")
	
	set_type(type)
	
	death_timer = Timer.new()
	death_timer.set_name("Death Timer")
	death_timer.one_shot = true
	add_child(death_timer)
	death_timer.start(death_time)
	death_timer.connect("timeout", self, "death_timer_timeout")
	
	
func area_entered(area):
	var damage_dealt = damage + (randf() * damage_randomness - damage_randomness * 0.5)
	var object = area.get_parent()
	
	if area.get_parent().name == "GreenPawn" and type != ORANGE and object.visible and not object.shielded:
		emit_signal("successful_hit", 1, damage_dealt)
		player_inside = 1
		if destructable:
			destroy()
			
	elif area.get_parent().name == "OrangePawn" and type != GREEN and object.visible and not object.shielded:
		emit_signal("successful_hit", 2, damage_dealt)
		player_inside = 2
		if destructable:
			destroy()

func area_exited(area):

	if ((player_inside == 1) and (area.get_parent().name == "GreenPawn")) or ((player_inside == 2) and (area.get_parent().name == "OrangePawn")):
		player_inside = 0


func _tick(): # if the this hazard is not destructable, it'll deal damage per-tick
	if player_inside != 0:
		emit_signal("successful_hit", player_inside, damage)

func set_type(type_in):
	type = type_in
	match type:
		NORMAL:
			set_modulate(Color("e0efef"))
		GREEN:
			set_modulate(global.GREEN_COLOR)
		ORANGE:
			set_modulate(global.ORANGE_COLOR)
		_:
			print("Error: Invalid projectile type; setting to NORMAL")
			type = NORMAL

func destroy():
	queue_free()
	

func death_timer_timeout():
	queue_free()

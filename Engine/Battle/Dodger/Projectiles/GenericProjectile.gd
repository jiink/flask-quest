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
	if get_tree().get_current_scene().name == "AttackTestingField":
		connect_to = get_tree().get_current_scene()
	else:
		connect_to = get_node("../../../..") # battlescene
	connect("successful_hit", connect_to, "hazard_has_hit")
	
	connect("area_entered", self, "area_entered")

	
	if not destructable: # if the this hazard is not destructable, it'll deal damage per-tick
		add_to_group("tick")
		connect("area_exited", self, "area_exited") # also use area_exited to keep track of players inside the hazard zone
	
	if face_center:
		if $"../../..".name == "DodgerField":
			look_at($"../../..".position)
		else:
			print("Warning: Projectile couldn't face field; trying other way")
			look_at(Vector2(192, 108))
	elif face_node != null:
		look_at(get_node(face_node).position)
		
	if face_center and face_node != "":
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
	var thingy = area.get_parent()
	var dfield = area.get_parent().get_node("../..")
#	var pstats = get_node("/root/PlayerStats")
#	print("something was hit...")
	
	if area.get_parent().name == "GreenSprite" and type != ORANGE and thingy.visible and not dfield.shielded:
		emit_signal("successful_hit", 1, damage_dealt)
		player_inside = 1
		if destructable:
			destroy()
			
	elif area.get_parent().name == "OrangeSprite" and type != GREEN and thingy.visible and not dfield.shielded:
		emit_signal("successful_hit", 2, damage_dealt)
		player_inside = 2
		if destructable:
			destroy()

func area_exited(area):

	if ((player_inside == 1) and (area.get_parent().name == "GreenSprite")) or ((player_inside == 2) and (area.get_parent().name == "OrangeSprite")):
		player_inside = 0


func _tick(): # if the this hazard is not destructable, it'll deal damage per-tick
	if player_inside != 0:
		emit_signal("successful_hit", player_inside, damage)

func set_type(type_in):
	type = type_in
	match type:
		NORMAL:
			set_modulate(Color("FFFFFF"))
		GREEN:
			set_modulate(Color("72D031"))
		ORANGE:
			set_modulate(Color("F68F31"))
		_:
			print("Error: Invalid projectile type; setting to NORMAL")
			type = NORMAL

func destroy():
	queue_free()
	

func death_timer_timeout():
	queue_free()

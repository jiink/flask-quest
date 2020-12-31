extends Node

onready var douglas_sobbing_scene = preload("res://NPC/Douglas/DouglasSobbing.tscn")

func start_douglas_fight():
	get_tree().get_current_scene().start_douglas_fight()

# When the battle is won, change some thing around.
# after the battle:
#	- there is a sobbing douglas on his knees who you can interact with
#	- the lights stop strobing
#	- the crowd is gone
#	- the realprophetpair is spawned at the base of the walkway

func douglas_defeated_setup():
	var current_scene = get_tree().get_current_scene()
	var ysort = current_scene.get_node("YSort")
	current_scene.douglas_defeated = true
	# remove the old douglas
	ysort.get_node("Douglas").queue_free()
	# spawn a sobbing douglas at the douglas sobbing location
	var douglas_sobbing = douglas_sobbing_scene.instance()
	ysort.add_child(douglas_sobbing)
	douglas_sobbing.position = $DouglasSobbingLocation.position

	# remove most of the crowd. if a member isn't removed, it stops dancing
	var crowd = current_scene.get_node("DouglistCrowd")
	var to_be_deleted = [] 
	for c in crowd.get_children():
		var chance = 0.95 # chance of member being deleted
		if randf() < chance:
			to_be_deleted.append(c)
		else:
			c.speed_scale = 0.07 # stop dancing so much
	for n in to_be_deleted:
		n.queue_free()


	# turn the party lights and spotlights off 
	current_scene.get_node("StrobePaletteSwap").visible = false
	current_scene.get_node("DougSpotlight").visible = false
	current_scene.get_node("DougSpotlightOnDougHimself").visible = false
	# turn the normal light on
	current_scene.get_node("PostBattlePaletteSwap").visible = true

	# spawn the realprophetpair at the bottom of the walkway and make them move up slowly
	var realprophetpair_scene = preload("res://NPC/RealProphetPair/RealProphetPair.tscn")
	var realprophetpair = realprophetpair_scene.instance()
	realprophetpair.position = $RealProphetPairStartLocation.position
	ysort.add_child(realprophetpair)

func _ready():
	global.connect("battle_won", self, "_on_battle_won")

func _on_battle_won():
	douglas_defeated_setup()


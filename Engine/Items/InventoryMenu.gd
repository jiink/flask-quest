extends Node2D

onready var manager = get_node("/root/ItemManager")
var open = false

func update_list():
	for item in manager.owned_items:
		var item_codename = item
		item = manager.item_list[item]
		var item_sprite = TextureRect.new()
		item_sprite.set_name(item.name)
		item_sprite.set_texture(load("res://Items/Sprites/%s.png" % item_codename))
		$GridContainer.add_child(item_sprite)

func _ready():
	update_list()
	
func _process(delta):
	if Input.is_action_just_pressed("b"):
		set_visible(!visible)
		get_tree().get_nodes_in_group("Player")[0].frozen = visible
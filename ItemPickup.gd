tool
extends Node2D

enum Mode {INTERACT, WALK_OVER}

var is_ingredient = false
export(String) var item_name setget set_item_name 
export(Mode) var mode = Mode.WALK_OVER
export(bool) var auto_sprite = true
export(bool) var auto_sprite_half_scale = true
export(bool) var shine_effect setget set_shine_effect
export(Texture) var custom_texture setget set_custom_texture
export(bool) var unlimited_if_item = false

func use():
	if is_ingredient:
		ItemManager.give_ingredient(item_name)
		queue_free()
	else:
		if ItemManager.give_item(item_name) and (not unlimited_if_item):
			queue_free()


func _ready():
	set_item_name(item_name)
	
	if shine_effect:
		var sprite = get_node_or_null("Sprite")
		if sprite == null:
			return
		var random_val = randf() * 100
		sprite.material.set('shader_param/offset', random_val)

	match mode:
		Mode.INTERACT:
			pass
		Mode.WALK_OVER:
			$Interaction.connect("body_entered", self, "_on_body_entered")
			

func interact():
	if mode != Mode.INTERACT:
		return

	use()

func _on_body_entered(body):
	if body == global.get_player():
		use()

func set_item_name(st):
	item_name = st
	var sprite = get_node_or_null("Sprite")
	if sprite == null:
		return
	
	if auto_sprite:
		var item_tex
		var file_to_check = File.new()
		var file_exists = file_to_check.file_exists("res://Items/Sprites/Ingredients/%s.png" % item_name)
		if file_exists:
			item_tex = load("res://Items/Sprites/Ingredients/%s.png" % item_name)
			sprite.set_texture(item_tex)
			is_ingredient = true
		else:
			file_to_check = File.new()
			file_exists = file_to_check.file_exists("res://Items/Sprites/%s.png" % item_name)
			if file_exists:
				item_tex = load("res://Items/Sprites/%s.png" % item_name)
				sprite.set_texture(item_tex)
			else:
				sprite.set_texture(null)
	
		if auto_sprite_half_scale:
			sprite.scale = Vector2(0.5, 0.5)
		else:
			sprite.scale = Vector2(1.0, 1.0)

func set_custom_texture(tx):
	custom_texture = tx
	var sprite = get_node_or_null("Sprite")
	if sprite == null:
		return
	#if Engine.editor_hint:
	sprite.texture = tx

func set_shine_effect(se):
	shine_effect = se
	var sprite = get_node_or_null("Sprite")
	if sprite == null:
		return
	if shine_effect:
		var new_material = load("res://Effects/Shaders/sweeping_shine_mat.tres")
		sprite.material = new_material
	else:
		sprite.material = null

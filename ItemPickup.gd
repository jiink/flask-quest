tool
extends Node2D

enum Mode {INTERACT, WALK_OVER}

export(String) var item_name setget set_item_name 
export(Mode) var mode = Mode.WALK_OVER
export(bool) var auto_sprite = true
export(bool) var auto_sprite_half_scale = true
export(Texture) var custom_texture setget set_custom_texture
export(bool) var unlimited = false

func use():
	if ItemManager.give_item(item_name) and (not unlimited):
		queue_free()


func _ready():
	set_item_name(item_name)

	match mode:
		Mode.INTERACT:
			pass
		Mode.WALK_OVER:
			$Interaction.connect("body_entered", self, "_on_body_entered")

func interact():
	if mode != Mode.INTERACT:
		return

	use()
	queue_free()

func _on_body_entered(body):
	if body == global.get_player():
		use()

func set_item_name(st):
	item_name = st
	var sprite = get_node_or_null("Sprite")
	if sprite == null:
		return
	
	if auto_sprite:
		var item_tex = load("res://Items/Sprites/%s.png" % item_name)
		if item_tex:
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

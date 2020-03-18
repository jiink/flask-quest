extends Sprite

export(String) var item_name = "base_pickup"

func interact():
	if ItemManager.give_item(item_name):
		queue_free()

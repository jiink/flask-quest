extends Sprite

func interact():
	ItemManager.give_item("elevator_card")
	queue_free()
extends Sprite

func interact():
	if (not ItemManager.has_item("elevator_card")) and ItemManager.give_item("elevator_card"):
		queue_free()

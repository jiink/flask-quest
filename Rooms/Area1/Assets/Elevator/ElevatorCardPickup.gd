extends Sprite

func interact():
	if ItemManager.give_item("elevator_card"):
		queue_free()
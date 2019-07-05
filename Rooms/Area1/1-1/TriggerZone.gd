extends Area2D

func _on_TriggerZone_body_entered(body):
	print("BODDDDY ENTERRRED: %s" % body)
	if body == get_tree().get_nodes_in_group("Player")[0]:
		if ItemManager.inventory.has("elevator_card"):
			print("ok, switching orange's state...")
			get_owner().set_orange_state(1)
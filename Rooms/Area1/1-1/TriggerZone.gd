extends Area2D

func _on_TriggerZone_body_entered(body):
	print("BODDDDY ENTERRRED: %s" % body)
	if body == get_tree().get_nodes_in_group("Player")[0]:
		print("%s%s" % [ItemManager.inventory.has("elevator_card"), get_owner().orange_state])
		if ItemManager.inventory.has("elevator_card") and (get_owner().orange_state == 2):
			print("ok, switching orange's state...")
			get_owner().set_orange_state(1)
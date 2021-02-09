extends Node2D

export(String) var main_dialogue = "DiagPiece"
var interactable = true

func interact():
	if interactable:
		DiagHelper.start_talk(self, main_dialogue)

func give_item(item_name):
	ItemManager.give_item(item_name)
	
func give_ingredient(ingredient_name):
	ItemManager.give_ingredient(ingredient_name)
	
func sell_item(item_name, price, success_diag, poor_diag, is_ingredient):
	interactable = false
	yield(get_tree().create_timer(0.1), "timeout")
	interactable = true
	if PlayerStats.dollars >= price:
		if is_ingredient:
			ItemManager.give_ingredient(item_name)
		else:
			ItemManager.give_item(item_name)
		PlayerStats.dollars -= price
		DiagHelper.start_talk(self, success_diag)
	else:
		DiagHelper.start_talk(self, poor_diag)

func run_external_func(node, function):
	var selected_node = get_node(node)
	selected_node.call(function)

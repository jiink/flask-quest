extends Node2D

func interact():
	DiagHelper.start_talk(self)

func give_item(item_name):
	ItemManager.give_item(item_name)
	
func give_ingredient(ingredient_name):
	ItemManager.give_ingredient(ingredient_name)
	
func sell_item(item_name, price, success_diag, poor_diag, is_ingredient):
	if PlayerStats.dollars >= price:
		if is_ingredient:
			ItemManager.give_ingredient(item_name)
		else:
			ItemManager.give_item(item_name)
		PlayerStats.dollars -= price
		DiagHelper.start_talk(self, success_diag)
	else:
		DiagHelper.start_talk(self, poor_diag)

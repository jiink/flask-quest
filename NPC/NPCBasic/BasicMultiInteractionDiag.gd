extends Node2D

export(Array, String) var branch_order
export(bool) var loop = false

var interactions_made = 0

func interact():
	var starting_branch = branch_order[interactions_made]
	if not (starting_branch == "" or starting_branch == null): # leaving it blank means no dialogue
		DiagHelper.start_talk(self, starting_branch)
	interactions_made += 1

	if loop:
		interactions_made = interactions_made % branch_order.size()
	else:
		interactions_made = clamp(interactions_made, 0, branch_order.size() - 1)


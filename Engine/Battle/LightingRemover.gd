extends Node

func remove_lighting(node):
	for N in node.get_children():
		if N.get_child_count() > 0:
			print("["+N.get_name()+"]")
			remove_lighting(N)
		else:
			if N.get("light_mask"):
				N.light_mask = 0
#            print("- "+N.get_name())
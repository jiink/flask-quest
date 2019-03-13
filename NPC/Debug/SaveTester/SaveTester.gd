extends Node2D

var state = "red"

func interact():
	if state == "red":
		state = "blue"
	else:
		state = "red"
	print("savetester state: " + state)
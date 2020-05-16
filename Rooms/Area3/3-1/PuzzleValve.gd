extends Node2D

var turned = false

signal puzzle_valve_turned

func _ready():
    connect("puzzle_valve_turned", get_node("../PuzzlePipeLeak"), "_on_puzzle_valve_turned")

func interact():
    if not turned:
        print("puzzle valve activated")
        emit_signal("puzzle_valve_turned")
        turned = true

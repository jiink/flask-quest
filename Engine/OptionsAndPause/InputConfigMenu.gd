extends Node2D

signal wait_for_input

onready var list = $InputList
var locked = false

func _ready():
	pass

func _process(delta):
	if not locked:
		if Input.is_action_just_pressed("confirm"):
			var target = list.get_child(0)
			print("telling button to listen...")
			connect("wait_for_input", target, "on_wait_for_input")
			emit_signal("wait_for_input")
			locked = true
			
func _input(ev):
    if ev is InputEventKey and ev.scancode == KEY_K and not ev.echo:
        pass
extends Node2D

var bubble_scene = preload("res://Engine/Battle/Dodger/Projectiles/OrbitingBubble.tscn")

onready var timer = $BubbleSpawnTimer

func _ready():
	pass

func _process(delta):
	pass

func _on_BubbleSpawnTimer_timeout():
	spawn_bubble()
	
	timer.start(1.7 + randf() * 0.6)

func spawn_bubble():
	var bubble = bubble_scene.instance()
	bubble.rotation_degrees = randi() % 359
	bubble.size = 1.5 + randf() * 0.8
	bubble.spin_speed = 0.005 + randf() * 0.02
	bubble.position = global.center
	add_child(bubble)
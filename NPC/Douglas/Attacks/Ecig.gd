extends Sprite

onready var vapor_scene = preload("res://NPC/Douglas/EcigVapor.tscn")

func _ready():
	$Timer.connect("timeout", self, "_timeout")

func _timeout():
	# choose a random path out of the three
	var path_num = randi() % 3 + 1 # 1 to 3
	var vapor = vapor_scene.instance()
	get_node("Path%s" % path_num).add_child(vapor)
	$Timer.start()

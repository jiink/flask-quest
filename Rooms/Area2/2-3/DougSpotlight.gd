extends TextureRect

var player

func _ready():
    add_to_group("tick")
    player = global.get_player(1)

func _tick():
    var random = randf()*0.1 + 0.95
    var new_scale = Vector2(random*1.5, random)
    # rect_scale
    # rect_scale.x = rect_scale.y * 1.5
    $Tween.interpolate_property(self, "rect_scale", null, new_scale, 0.1)
    $Tween.start()

func _process(delta):
    rect_position.x = player.position.x - 61
    rect_position.y = player.position.y - 64

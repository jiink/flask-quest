extends TextureRect

var depth = 0.0


func _process(delta):
	if global.get_player(1).position.x >= -1660:
		depth = global.get_player(1).position.x * -0.0005 - 0.42
		depth = clamp(depth, 0, 100)
	else:
		depth = global.get_player(1).position.x * 0.0005 + 1.24
		depth = clamp(depth, 0, 100)
	$"../../../YSort/Player/PosLabel".text = "%d\n%s" % [global.get_player(1).position.x, depth]
	get_material().set_shader_param("depth", depth)
	#while player goes from -800 to -2500, depth goes from 0 to 0.5 to 0 again

extends TileMap

onready var camera = global.get_camera()

func _process(delta):
	if camera:
		get_material().set_shader_param("player_pos", camera.get_camera_screen_center())

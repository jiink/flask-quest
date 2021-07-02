extends CanvasLayer


onready var camera = global.get_camera()
var cam_pos = Vector2(0,0)
export var transform_scale = -0.005

func _process(delta):
	cam_pos = camera.get_camera_screen_center()
	transform.y.x = cam_pos.x * transform_scale

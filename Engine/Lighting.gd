extends ColorRect

############# 'inspired' by https://www.patreon.com/posts/42040761

var img = Image.new()
var texture = ImageTexture.new()
export(float, 0.0, 5.0, 0.05) var lerp_weight = 0.5

func _ready():
	img.create(256, 2, false, Image.FORMAT_RGBAH)
	
func update_texture():
	var lights = get_tree().get_nodes_in_group("lights")
	img.lock()
	for i in lights.size():
		var light = lights[i]
#		if light is Position2D: #####EMERGENCY CHECK WE MAY OR MAY NOT NEED
		var light_pos = light.global_position.floor() # That's right! No more jiggle lights!
		img.set_pixel(i, 0, Color( \
			light_pos.x, light_pos.y, \
			light.strength, light.radius
			))
		img.set_pixel(i, 1, light.color)
		
		
	img.unlock()
	
	texture.create_from_image(img)
	
	material.set_shader_param("n_lights", lights.size())
	material.set_shader_param("light_data", texture)


func _process(delta):
	update_texture()
	var t = Transform2D(0, Vector2())
	if !Engine.editor_hint:
		var camera = global.get_camera()
		var canvas_transform = camera.get_canvas_transform()
		var top_left = -canvas_transform.origin / canvas_transform.get_scale()
		t = Transform2D(0, top_left)
		material.set_shader_param("global_transform", t)
		

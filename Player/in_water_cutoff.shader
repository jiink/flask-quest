shader_type canvas_item;
uniform float row_count = 10.0; // How many rows does your spritesheet have?
uniform float cutoff = 0.7;
void fragment() {
	COLOR = texture(TEXTURE,UV);
	
	float UV_Y = (UV.y * row_count) - floor(UV.y * row_count);
	
	//COLOR = vec4(UV_Y, 0.0, 0.0, 1.0);//COLOR.a);
	COLOR.a = float(UV_Y < cutoff) * COLOR.a;
}
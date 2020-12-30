shader_type canvas_item;

uniform float freq = 8.0;
uniform float brightness = 1.0;
uniform float banding = 2.0;
uniform float speed = 1.0;
uniform float offset = 0.0;

void fragment(){
	vec4 tex_val = texture(TEXTURE, UV);
	float time_offset = 0.0;
	time_offset += (TIME * speed);
	
	float bands = sin(((UV.x + offset + time_offset + UV.y) * freq)) - brightness;
	
	float limited_pal_bands = ceil(pow(bands, 3.0));
	
//	COLOR = vec4(bands, 0.0, 0.0, 1.0);
	COLOR = vec4(tex_val.rgb + clamp(limited_pal_bands, -1.0, 1.0), 0.0) + tex_val.a;
}
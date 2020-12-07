shader_type canvas_item;

uniform float brightness = 0.2;
// vec3(0.299, 0.587, 0.114) for blackandwhite
uniform vec3 color = vec3(2, 2, 2);
void fragment() {
	//COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0) * vec4(r_level, g_level, b_level, a_level);
	vec3 c_screen = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	float c_tex = texture(TEXTURE, UV).r;
	float c_tex_inverse = 1.0 - c_tex;
	//vec4 c_bw = 
	vec3 c_bw = COLOR.rgb * dot(c_screen, vec3(0.299, 0.587, 0.114));
	COLOR.rgb = ((c_screen * c_tex_inverse + (c_bw * color * c_tex)) + c_tex * brightness) ;
	
}
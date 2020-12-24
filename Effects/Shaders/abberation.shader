shader_type canvas_item;


void fragment() {
	vec2 uv = SCREEN_UV;
	
	float cr = textureLod(SCREEN_TEXTURE, uv, 0.0).r;
	float cg = textureLod(SCREEN_TEXTURE, uv+(0.002 * cos(TIME*0.9)), 0.0).g;
	float cb = textureLod(SCREEN_TEXTURE, uv+(0.004 * sin(TIME)), 0.0).b;
	vec3 c = vec3(cr, cg, cb);
	COLOR.rgb = c;
}
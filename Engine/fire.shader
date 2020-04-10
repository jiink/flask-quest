shader_type canvas_item;


void fragment(){
//	COLOR = texture(TEXTURE, UV);
	vec4 col = texture(TEXTURE, UV);
	col = vec4(COLOR.r + UV.y * 0.7 * (0.4*sin(TIME*3.5) + 0.8), COLOR.g, COLOR.b, 1.0);
	COLOR = col;
//COLOR.rgb = vec3(0.2*sin(TIME*2.0 + UV.y*5.0 + sin(UV.x*(sin(TIME)*40.0)))+0.5, COLOR.g, sin(UV.x*(cos(TIME)*20.0)));
}
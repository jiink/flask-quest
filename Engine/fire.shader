shader_type canvas_item;


void fragment(){
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb = vec3(COLOR.r + UV.y * 0.7 * (0.4*sin(TIME*3.5) + 0.8), COLOR.g, COLOR.b);
//COLOR.rgb = vec3(0.2*sin(TIME*2.0 + UV.y*5.0 + sin(UV.x*(sin(TIME)*40.0)))+0.5, COLOR.g, sin(UV.x*(cos(TIME)*20.0)));
}
shader_type canvas_item;


void fragment(){
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb = vec3(COLOR.r + UV.y * sin(TIME*3.0), COLOR.g + UV.y * sin(TIME*1.0), COLOR.b + UV.y * cos(TIME*2.0));
}
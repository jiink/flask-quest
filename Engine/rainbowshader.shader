shader_type canvas_item;

void fragment(){
	COLOR = texture(TEXTURE, UV);
	float intensity = sin(TIME*1.24) * 2.0 + 4.0;
	float uvy = float(round(log(UV.y * intensity)));
	uvy *= 0.3;
	COLOR.rgb = vec3(COLOR.r + uvy * sin(TIME*3.0), COLOR.g + uvy * sin(TIME*1.0), COLOR.b + uvy * cos(TIME*2.0));
//COLOR.rgb = vec3(0.2*sin(TIME*2.0 + UV.y*5.0 + sin(UV.x*(sin(TIME)*40.0)))+0.5, COLOR.g, sin(UV.x*(cos(TIME)*20.0)));
}
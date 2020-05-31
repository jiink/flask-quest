shader_type canvas_item;

uniform float fillAmount;

void fragment(){
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb = vec3(COLOR.r + UV.y * sin(TIME*3.0), COLOR.g + UV.y * sin(TIME*1.0), COLOR.b + UV.y * cos(TIME*2.0));
//COLOR.rgb = vec3(0.2*sin(TIME*2.0 + UV.y*5.0 + sin(UV.x*(sin(TIME)*40.0)))+0.5, COLOR.g, sin(UV.x*(cos(TIME)*20.0)));
}
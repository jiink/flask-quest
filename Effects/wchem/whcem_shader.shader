shader_type canvas_item;

uniform float fill_amount;
uniform float wobble;

void fragment(){
	float a = 0.0;
	if(UV.y + wobble * (UV.x - 0.4) > fill_amount){
		a = 1.0;
	}
	vec4 col = texture(TEXTURE, UV);
	COLOR = vec4(1.0, 1.0, 1.0, a * col.a);
	// step(fill_amount+0.05, UV.y)
//COLOR.rgb = vec3(UV.y, 0.0, 0.0);
}
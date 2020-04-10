shader_type canvas_item;

uniform sampler2D pic;

void fragment(){
//	COLOR = vec4(COLOR.r - UV.x, COLOR.g, COLOR.b, texture(TEXTURE, UV).a);
	COLOR.a = texture(TEXTURE, UV).a;
	if(COLOR.a != 0.0){
		COLOR = texture(pic, vec2(UV.x*2.0 + TIME*.1 ,UV.y*3.0 + TIME*.2));
	}
}
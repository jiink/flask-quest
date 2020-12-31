shader_type canvas_item;

uniform sampler2D pic;
uniform vec2 direction = vec2(1.0,0.0);
 
void fragment(){
//	COLOR = vec4(COLOR.r - UV.x, COLOR.g, COLOR.b, texture(TEXTURE, UV).a);
	COLOR.a = texture(TEXTURE, UV).a;
	if(COLOR.a != 0.0){
		vec2 move = direction * TIME;
		COLOR = texture(pic, UV + move);//vec2(UV.x*2.0 + TIME*.1 ,UV.y*3.0 + TIME*.2));
	}
}
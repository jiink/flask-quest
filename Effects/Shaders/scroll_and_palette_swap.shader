shader_type canvas_item;

uniform sampler2D pic;

uniform int speed = 4; // fps
uniform int pal_size = 6; // number of colors you fill in in the array
uniform int source_pal_size = 4; // shades of green on the sprite

uniform vec4 p1 :hint_color;
uniform vec4 p2 :hint_color;
uniform vec4 p3 :hint_color;
uniform vec4 p4 :hint_color;
uniform vec4 p5 :hint_color;
uniform vec4 p6 :hint_color;
uniform vec4 p7 :hint_color;
uniform vec4 p8 :hint_color;
uniform vec4 p9 :hint_color;
uniform vec4 p10:hint_color;
uniform vec4 p11:hint_color;
uniform vec4 p12:hint_color;
uniform vec4 p13:hint_color;
uniform vec4 p14:hint_color;
uniform vec4 p15:hint_color;
uniform vec4 p16:hint_color;

void fragment(){
//	COLOR = vec4(COLOR.r - UV.x, COLOR.g, COLOR.b, texture(TEXTURE, UV).a);
	COLOR.a = texture(TEXTURE, UV).a;
	if(COLOR.a != 0.0){
		COLOR = texture(pic, vec2(UV.x*2.0 + TIME*.1 ,UV.y*3.0 + TIME*.2));
	}
	
	vec4 pal[] = {p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16}; // crime?
	
	if(COLOR.r == 0.0 && COLOR.b == 0.0){
		float pal_sample = COLOR.g;
		int offset = int(TIME*float(speed));
		vec4 picked_col = pal[(int(COLOR.g * float(source_pal_size - 1) + 0.5) + offset) % pal_size ];
		COLOR = vec4(picked_col.r, picked_col.g, picked_col.b, COLOR.a * picked_col.a);
	}
}
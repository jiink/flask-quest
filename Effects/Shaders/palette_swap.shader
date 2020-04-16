shader_type canvas_item;

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
	vec4 pal[] = {p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16}; // crime
	
	vec4 col = texture(TEXTURE, UV);
	if(col.r == 0.0 && col.b == 0.0){
		float pal_sample = col.g;
		int offset = int(TIME*float(speed));
	
		col = pal[(int(col.g * float(source_pal_size - 1) + 0.5) + offset) % pal_size ];
	}
	COLOR = col;
}
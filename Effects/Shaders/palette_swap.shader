shader_type canvas_item;

uniform int speed = 4; // fps
uniform int pal_size = 6; // number of colors you fill in in the array
uniform int source_pal_size = 4; // shades of green on the sprite

uniform int p1 = 0x000000;
uniform int p2 = 0x000000;
uniform int p3 = 0x000000;
uniform int p4 = 0x000000;
uniform int p5 = 0x000000;
uniform int p6 = 0x000000;
uniform int p7 = 0x000000;
uniform int p8 = 0x000000;
uniform int p9 = 0x000000;
uniform int p10= 0x000000;
uniform int p11= 0x000000;
uniform int p12= 0x000000;
uniform int p13= 0x000000;
uniform int p14= 0x000000;
uniform int p15= 0x000000;
uniform int p16= 0x000000;

void fragment(){
	int pal[] = {p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16}; // crime
	
	vec4 col = texture(TEXTURE, UV);
	if(col.r == 0.0 && col.b == 0.0){
		float pal_sample = col.g;
		int offset = int(TIME*float(speed));
		
		int picked_col = pal[(int(col.g * float(source_pal_size - 1) + 0.5) + offset) % pal_size ];
		col.r = float( (picked_col >> 16) & 0xFF ) / 255.0;
		col.g = float( (picked_col >> 8) & 0xFF ) / 255.0;
		col.b = float( picked_col & 0xFF ) / 255.0;
	}
	COLOR = col;
}
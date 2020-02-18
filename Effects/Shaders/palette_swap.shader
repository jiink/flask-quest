shader_type canvas_item;

uniform sampler2D palette_tex;
uniform int pal[];
//const float arr1[2] = float[2]{0.0, 0.1};
void fragment(){
//	float arr1[] = {0.0, 0.5, 1.0};
//	vec3 pal[] = {vec3(0.0, 0.0, 0.0), vec3(0.1, 0.0, 0.1), vec3(0.3, 0.2, 0.3), vec3(0.4, 0.0, 0.4)};
//	vec3 pal[] = {
//		vec3(0.0, 0.0, 0.0),
//		vec3(0.1, 0.0, 0.1),
//		vec3(0.3, 0.2, 0.3),
//		vec3(0.4, 0.0, 0.4)
//		};
	int pal[] = {
			0x5EE5DA,
			0xE8DDCB,
			0xE58D00,
			0xE51C00
			};
	vec4 col = texture(TEXTURE, UV);
	if(col.r == 0.0 && col.b == 0.0){
		float pal_sample = col.g;
//		col = texture(palette_tex, vec2(pal_sample, 0));
//		col = vec4(pal[int(col.g * 3.0)], 1.0);
		int picked_col = pal[int(col.g * 3.0)];
//		int picked_col = pal[0];
		col.r = float( (picked_col >> 16) & 0xFF ) / 255.0;
		col.g = float( (picked_col >> 8) & 0xFF ) / 255.0;
		col.b = float( picked_col & 0xFF ) / 255.0;
	}
	COLOR = col;
}
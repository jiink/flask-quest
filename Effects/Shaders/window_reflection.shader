shader_type canvas_item;

//This shader needs a distortion map and a brightness map that correspond with a tileset.
//All maps, including the background image, need to be in monochromatic green (in order to use the palette)
//Transparency in the maps, to limit their application to only certain parts of tiles,
//is marked with monochromatic red.

const int pal_size = 6; // number of colors you fill in in the array
const int source_pal_size = 6; // shades of green on the sprite

uniform float contrast = 0.15;
uniform float tilemap_contrast = 2.5;
uniform float distortion = -0.02;

uniform sampler2D bg_image :hint_albedo;
uniform sampler2D brightness_map : hint_albedo;
uniform sampler2D distortion_map : hint_albedo;

uniform vec4 p1 :hint_color; //332b63
uniform vec4 p2 :hint_color; //683389
uniform vec4 p3 :hint_color; //b33c94
uniform vec4 p4 :hint_color; //e26346
uniform vec4 p5 :hint_color; //ffb576
uniform vec4 p6 :hint_color; //fcffe4

void fragment(){
	vec4 pal[] = {p1,p2,p3,p4,p5,p6};
	
	vec4 base_tex = texture(TEXTURE, UV);
	vec4 distort_val = texture(distortion_map, UV);
	vec2 distort_uv = vec2(SCREEN_UV.x, SCREEN_UV.y + (distort_val.g * distortion));
	vec4 brightness_col = texture(brightness_map, UV);
	vec3 screen = textureLod(SCREEN_TEXTURE,SCREEN_UV, 0.0).rgb;
	vec4 bg_image_val = texture(bg_image, vec2(distort_uv.x, 1.0 - distort_uv.y));
	
	vec4 combined_maps = vec4((brightness_col.rgb / tilemap_contrast) + bg_image_val.rgb, brightness_col.a);
	
	vec4 final_output;
	
	if(combined_maps.r == 0.0){
		float pal_sample = combined_maps.g;
		vec4 picked_col = pal[int(clamp(combined_maps.g / contrast, -1.0, 5.0))];
		final_output = vec4(picked_col.rgb, 1.0);
	}
	
	vec3 culled_base_tex = clamp(base_tex.rgb - (1.0 - brightness_col.rrr), 0.0, 1.0);
	
	COLOR = vec4(final_output.rgb + culled_base_tex, base_tex.a);
}
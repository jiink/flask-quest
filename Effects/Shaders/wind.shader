shader_type canvas_item;

uniform sampler2D noise : hint_albedo;
uniform float noise_distortion;
uniform float dist_speed_x;
uniform float dist_speed_y;
uniform float speed_x;
uniform float speed_y;
uniform float intensity;
//uniform sampler2D noise : hint_albedo;

void fragment(){
//	vec4 tex_val = texture(TEXTURE, UV);
	vec3 noise_tex_b = texture(noise, UV).rgb;
	vec2 distorted_uv = vec2(UV.x + (noise_distortion * noise_tex_b.x) + (TIME * dist_speed_x),
	UV.y + (noise_distortion * noise_tex_b.y) + (TIME * dist_speed_y));
	vec3 col = textureLod(SCREEN_TEXTURE,SCREEN_UV,0.0).rgb;
	vec3 noise_tex = texture(noise, distorted_uv + vec2(TIME * speed_x, TIME * speed_y)).rgb; 
	vec3 noise_tex_post = noise_tex;
	COLOR = vec4(col + noise_tex_post, intensity);
}
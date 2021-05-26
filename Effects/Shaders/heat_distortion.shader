shader_type canvas_item;

uniform sampler2D noise : hint_albedo;
uniform float noise_distortion;
uniform vec2 speed;
uniform float dist_speed_x;
uniform float dist_speed_y;
uniform float speed_x;
uniform float speed_y;
uniform float intensity;
uniform vec2 scale;
uniform float bias;
uniform float other_bias;
uniform vec2 magic_numbers;
//uniform sampler2D noise : hint_albedo;

void fragment(){
//	vec4 tex_val = texture(TEXTURE, UV);
	vec3 noise_tex_b = texture(noise, (SCREEN_UV * scale) + TIME*speed).rgb;
//	vec4 noise_tex_b_texel = texelFetch(noise, ivec2((SCREEN_UV * scale) + TIME * speed), int(dist_speed_y));
	vec2 bias_uv = SCREEN_UV * 2.0 - 1.0;
	float dist = distance(bias_uv, vec2(0.0,0.0));
	vec3 noise_bias = clamp(noise_tex_b - (other_bias - dist * bias), 0.0, 1.0);
	vec2 distorted_scrn_uv = SCREEN_UV + (noise_bias.xy * intensity);
	
//	vec2 rounded_distorted_scrn_uv = vec2(
//		floor(distorted_scrn_uv.x * magic_numbers.x) / magic_numbers.x,
//		floor(distorted_scrn_uv.y * magic_numbers.y) / magic_numbers.y
//		);
	vec3 col = textureLod(SCREEN_TEXTURE,distorted_scrn_uv,0.0).rgb;
	COLOR = vec4(col, 1.0);
}
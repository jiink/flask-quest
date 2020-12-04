shader_type canvas_item;

// seperated into components so AnimationPlayer can interpolate the values
uniform float r_level = 1.0;
uniform float g_level = 1.0;
uniform float b_level = 1.0;
uniform float a_level = 1.0;

void fragment() {
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0) * vec4(r_level, g_level, b_level, a_level);
}
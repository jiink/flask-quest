shader_type canvas_item;

uniform vec2 direction = vec2(1.0,0.0);
uniform vec2 wobble_dir = vec2(0.0,0.0);
uniform float speed_scale = 0.05;

void fragment(){

	vec2 move = direction * TIME * speed_scale;
	vec2 wobble = wobble_dir * sin(TIME) * speed_scale;

	COLOR = texture(TEXTURE, UV + move + wobble);   
}
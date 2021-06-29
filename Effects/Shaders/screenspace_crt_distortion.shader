shader_type canvas_item;

uniform vec2 range = vec2(0.0, 0.053);
uniform float speed = 1.5;
uniform float color_speed = 2.0;
uniform float offset = 0.005;
uniform float col_subt_max_val = 0.1;


void fragment(){
	vec2 distorted_uv = SCREEN_UV;
	
	vec2 upd_range = range + tan(TIME * speed);
	
	if(distorted_uv.y >= upd_range.x && distorted_uv.y <= upd_range.y){
		distorted_uv.x += offset;
	}
	
	vec4 col = textureLod(SCREEN_TEXTURE, distorted_uv, 0.0);
	
	col.rgb -= vec3(sin(TIME * color_speed) * col_subt_max_val + col_subt_max_val);
	
	COLOR = col;
}
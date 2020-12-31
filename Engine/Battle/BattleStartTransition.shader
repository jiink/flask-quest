shader_type canvas_item;

uniform float frequency=0;
uniform float depth = 0.0;

void fragment() {
	
	vec2 uv = SCREEN_UV;
	uv.x += sin((uv.y + 0.1 * uv.x)*frequency+TIME)*depth;
	uv.x = clamp(uv.x,0,1);
	uv.y += sin(uv.x*(frequency*0.8)+TIME*0.8)*depth*2.0;
	uv.y = clamp(uv.y,0,1);
	
	vec3 c = textureLod(SCREEN_TEXTURE,uv,0.0).rgb;
	
	float v = dot(c,vec3(0.299, 0.587, 0.114));
	
	COLOR.rgb= COLOR.rgb*v;
}

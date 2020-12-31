// based off of Breath Potter's Tunnel https://www.shadertoy.com/view/4st3WX
shader_type canvas_item;

void fragment(){
	COLOR = texture(TEXTURE, UV);
	if(COLOR.r < 0.5){
		vec2 iResolution = (1.0 / SCREEN_PIXEL_SIZE);
		vec2 uv = FRAGCOORD.xy / iResolution.xy / .5 - 1.;
		uv.x *= iResolution.x / iResolution.y;

		// make a tube
		float f = 1. / length(uv);

		// add the angle
		f += atan(uv.x, uv.y) / acos(0.0);

		// let's roll
		f -= TIME;

		// make it black and white
		// old version without AA: f = floor(fract(f) * 2.);
		// new version based on Shane's suggestion:
		f = floor(fract(f) * 3.);

		// add the darkness to the end of the tunnel
		f *= sin(length(uv) - .0);

		COLOR *= vec4(f, f, f, 1.0);
	}
}
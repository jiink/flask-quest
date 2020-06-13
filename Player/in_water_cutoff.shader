shader_type canvas_item;

uniform float cutoff = 0.6;

void fragment(){
	if(UV.y < cutoff){
		COLOR = texture(TEXTURE, UV);
	}else{
		COLOR = vec4(0.0);
	}
}

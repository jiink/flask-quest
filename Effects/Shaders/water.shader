shader_type canvas_item;

uniform float speed_scale = 0.05;

void fragment(){

     float move = TIME * speed_scale;
     COLOR = texture(TEXTURE, vec2(UV.x + move, UV.y + 0.06*sin(UV.x*6.283 + TIME*5.0)));   
}
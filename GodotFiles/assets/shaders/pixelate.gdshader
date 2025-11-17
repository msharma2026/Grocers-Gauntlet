shader_type canvas_item;

uniform float block_size : hint_range(1.0,20.0) = 4.0; 

void fragment() {
    vec2 block = block_size * TEXTURE_PIXEL_SIZE;
    vec2 uv = floor(UV / block) * block;
    COLOR = texture(TEXTURE, uv);
}
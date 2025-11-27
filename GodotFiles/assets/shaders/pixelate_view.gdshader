shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float block_size : hint_range(1.0,100.0) = 4.0;

void fragment() {
    vec2 block = block_size * SCREEN_PIXEL_SIZE;
    vec2 uv = floor(SCREEN_UV / block) * block;
    COLOR = texture(SCREEN_TEXTURE, uv);
}
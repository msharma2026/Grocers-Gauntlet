shader_type canvas_item;


uniform vec3 target_color : source_color = vec3(0.0, 1.0, 0.0);


uniform float intensity : hint_range(0.0, 1.0) = 1.0;


void fragment() {
    vec4 pixelColor = texture(TEXTURE, UV);
    float brightness = (pixelColor.r + pixelColor.g + pixelColor.b) / 3.0;
    vec4 grayScale = vec4(brightness, brightness, brightness, pixelColor.a);
    COLOR = grayScale * vec4(target_color,1.0);
}


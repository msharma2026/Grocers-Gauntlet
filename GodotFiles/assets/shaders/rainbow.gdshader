shader_type canvas_item;

uniform float speed : hint_range(0.0,3.0) = 1.0;
uniform float intensity : hint_range(0.0,1.0) = 0.5;

void fragment() {
    vec4 base = texture(TEXTURE, UV);

    float t = UV.x + TIME * speed;

    vec3 rainbow = vec3(
        sin(6.28318 * (t))       * 0.5 + 0.5,
        sin(6.28318 * (t + 0.33)) * 0.5 + 0.5,
        sin(6.28318 * (t + 0.66)) * 0.5 + 0.5
    );


    vec3 rgb = base.rgb + rainbow * intensity;

    rgb = clamp(rgb, 0.0, 1.0);

    COLOR = vec4(rgb, base.a);
}
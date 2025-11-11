shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float outline_thickness : hint_range(0.5, 5.0, 0.5) = 5;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float alpha = tex.a;
	if (alpha > 0.0) {
		COLOR = tex;
	}
	else {

		vec2 pixel = TEXTURE_PIXEL_SIZE * outline_thickness;
		float outline_alpha = 0.0;

		for (int x = -1; x <= 1; x++) {
			for (int y = -1; y <= 1; y++) {
				vec2 offset = vec2(float(x), float(y)) * pixel;
				outline_alpha = max(outline_alpha, texture(TEXTURE, UV + offset).a);
			}
		}

		if (outline_alpha > 0.0) {
			COLOR = vec4(outline_color.rgb, outline_color.a * outline_alpha);
		} else {
			COLOR = vec4(0.0);
		}
	}
}

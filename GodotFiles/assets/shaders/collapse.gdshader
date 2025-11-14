shader_type canvas_item;



void fragment() {
	vec4 t = texture(TEXTURE,UV);
	float d = length(UV - 0.5);
	float radius = smoothstep(0.0, 1.0, mod(TIME * 0.3, 1.0)) * 25.0;
	vec2 s = TEXTURE_PIXEL_SIZE * radius;
	vec4 chosen = t;
	for(float x = -1.0 ; x <= 1.0; x++) {
		for(float y = -1.0; y <= 1.0; y++) {
			vec4 at = texture(TEXTURE,UV + vec2(x,y) * s);
			if(length(at) < length(chosen)) {
				chosen = at;
			}
		}
	}
	COLOR = chosen;
}
//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

shader_type canvas_item;

uniform float darkened_rate : hint_range(-1.0,1.0) = 0.0;

void fragment() {
	vec4 OG_COLOR = texture(TEXTURE,UV);
	if(OG_COLOR.a > 0.0) {
		if(darkened_rate > 0.0)
			COLOR = mix(OG_COLOR,vec4(0.0,0.0,0.0,1.0),darkened_rate);
		else {
			float light_color_rate = abs(darkened_rate);
			COLOR = mix(OG_COLOR,vec4(1.0,1.0,1.0,1.0),light_color_rate);
		}
	}

}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

shader_type canvas_item;

uniform float disintegration_depth : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D NOISE_TEX: repeat_enable, filter_nearest;
uniform vec2 set_random = vec2(0.0,0.0);

void fragment() {

	float texture_limiter = texture(NOISE_TEX,UV + set_random).r;
	if(texture_limiter < disintegration_depth) {
		COLOR.a = 0.0;
	}
	else if(texture_limiter * 0.9 < disintegration_depth) {
		COLOR.rgb = vec3(1,0.7,0);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

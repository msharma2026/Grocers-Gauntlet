shader_type canvas_item;

uniform float blur_amount: hint_range(0.0,5.0) = 0.0;

void fragment() {
	vec2 pixel = TEXTURE_PIXEL_SIZE;
	vec4 sum = vec4(0.0);
	float sample_radius  = blur_amount;
	float divider = 0.0;
	vec4 base_color = texture(TEXTURE,UV);
	// Called for every pixel the material is visible on.
	for(float x = -sample_radius; x <= sample_radius; x++) {
		for(float y = -sample_radius; y <= sample_radius; y++) {
			vec2 offset = vec2(x,y) * pixel;
			vec4 adjacent_color = texture(TEXTURE, UV + offset);
			//if(base_color.a == 0.0 || adjacent_color.a > 0.0){
			//	sum += adjacent_color;
			//	divider++;
			//}
			sum += adjacent_color;
			divider++;
			
		}
	}
	
	COLOR = sum / divider; 
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

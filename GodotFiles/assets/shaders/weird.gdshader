shader_type canvas_item;


void fragment() {
	
	float b = texture(TEXTURE,UV).a;
    float wave = sin(b * 20.0 + TIME * 4.0); 
    float x = UV.x + wave * 0.02;              

    COLOR = texture(TEXTURE, vec2(x, UV.y));
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

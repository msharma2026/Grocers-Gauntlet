shader_type canvas_item;
uniform float speed : hint_range(0.0,20.0) = 2.0; //don't put this above 20 unless you want to induce seizures

void fragment() {
	float pulse = sin(TIME * speed) * 0.5 + 0.5;
	
	vec4 current_color = texture(TEXTURE, UV);
	vec3 target = vec3(current_color.r * 1.3,0.0,0.0);
	COLOR.rgb = mix(current_color.rgb,target,pulse);

}



//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

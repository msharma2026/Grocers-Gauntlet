shader_type canvas_item;
uniform float speed = 2; //don't put this above 20 unless you want to induce seizures

void fragment() {
	vec4 current_color = texture(TEXTURE, UV);
	COLOR.rgb = vec3(sin(TIME * speed) * 0.5 + 0.5,current_color.g,current_color.b);

}



//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

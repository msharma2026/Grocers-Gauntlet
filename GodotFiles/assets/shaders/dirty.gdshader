shader_type canvas_item;

uniform sampler2D noise_tex;
uniform float dust_rise : hint_range(0.0, 1.0) = 1.0;
uniform float dust_cutoff = 0.2;


void fragment() {
    vec4 base = texture(TEXTURE, UV);
	float y = UV.y;
	float dist_from_cutoff = dust_rise - y;
	float alpha = texture(TEXTURE,UV).a;
	if(alpha > 0.0) {
		float intensity = texture(noise_tex,UV).b;
		COLOR.rgb = texture(TEXTURE,UV).rgb  * (intensity);
		
	}
	
	
}
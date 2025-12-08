shader_type canvas_item;

uniform sampler2D noise_tex;
uniform float noise_scale : hint_range(0.5, 8.0) = 2.0;
uniform float dirt_strength : hint_range(0.0, 2.0) = 1.2;

void fragment() {
    vec4 base = texture(TEXTURE, UV);

    if (base.a <= 0.0) {
        COLOR = vec4(0.0);
    }
	else {
	    vec2 nuv = UV * noise_scale;
	    float n = texture(noise_tex, nuv).r;

	    float dirt = n;

	    vec3 final_rgb = base.rgb * (1.0 - dirt * dirt_strength);
	    COLOR = vec4(final_rgb, base.a);
	}
}
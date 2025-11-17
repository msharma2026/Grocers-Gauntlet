shader_type canvas_item;
uniform sampler2D noise_texture: repeat_enable, filter_nearest;
uniform float speed = 0.02;

void fragment() {
	float fade = smoothstep(0.0, 0.5
	, UV.y);  
	
	vec2 uv = UV + speed * TIME;
	float noise = texture(noise_texture,uv).r;
	float fog = noise * 2.0 - 0.4;
	COLOR.a = fog/5.0 * fade;
}



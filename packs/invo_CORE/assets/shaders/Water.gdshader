shader_type canvas_item;

uniform sampler2D noise;
uniform sampler2D gradient;
uniform sampler2D modulate;

void fragment() {
	
	vec2 suv = SCREEN_UV; 
	vec2 pxs = SCREEN_PIXEL_SIZE * 4.0;
	vec2 uv = floor(suv/pxs)*pxs;
	float t = TIME * 0.09;
	
	vec2 d = vec2(cos(TIME * 6.0 + TIME + suv.x * 150.0), cos(TIME * 6.0 + TIME + suv.x * 150.0)) * 0.0015;
	//vec2 d = vec2(texture(noise, suv*4.0 + t).r - 0.5, texture(noise, suv*4.0 + 0.04 + t).r - 0.5) * 0.02;
	
	vec4 bg = texture(SCREEN_TEXTURE, suv + d) * texture(modulate, vec2(1.0-UV.y, 0.0));

	vec4 dcol = (
			texture(noise, uv * 3.0 * vec2(1.0, 2.0) + t + 0.53) +
			texture(noise, uv * 4.0 * vec2(1.0, 2.0) + vec2(t, -t))
		) * 0.7;
	
	vec4 col = texture(gradient, vec2( dcol.r, 0.0)) * 1.2;
	col.a *= 1.0;
	
	COLOR = vec4(bg.rgb  * (1.0 - (1.0 - col.rgb) * col.a) + col.rgb * col.a, 1.0);
}
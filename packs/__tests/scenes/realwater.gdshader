shader_type canvas_item;

uniform vec4 foam_color : source_color;
uniform vec4 water_color : source_color;
uniform sampler2D back : filter_nearest_mipmap;
uniform sampler2D noise;

float grid (float x, float g) {
	return floor(x/g)*g;
}

float wave(float x) {
	float y = x * 32.0 + TIME * 4.0;
	return sin(y);
	//return texture(noise, vec2(x * 0.4, TIME)).g * 2.0 - 1.0;
}

void fragment() {
	
	float dx = grid(UV.x + 0.5, TEXTURE_PIXEL_SIZE.x) * 32.0;
	float dy = grid(UV.y + 0.5, TEXTURE_PIXEL_SIZE.y) * 32.0 + TIME * 2.0;
	float d = round(wave(UV.x)) * TEXTURE_PIXEL_SIZE.y - TEXTURE_PIXEL_SIZE.y;
	float d2 = round(sin(dy)) * TEXTURE_PIXEL_SIZE.x;
	vec2 uv = UV + vec2(0, d);
	vec4 colA = texture(TEXTURE, UV);
	vec4 col = texture(TEXTURE, uv);
	vec4 cout = vec4(0.0, 0.0, 0.0, 0.0);

	// Colour the Water
	if (colA == vec4(1.0, 0.0, 0.0, 1.0)) {
		cout = water_color * texture(back, (UV) + vec2(d2, 0));
	}

	// Colour the Foam
	if (col == vec4(0.0, 1.0, 0.0, 1.0)) {
		cout = foam_color;
	}

	COLOR = cout;
}

shader_type canvas_item;

uniform sampler2D emission_map;
uniform float strength;

void fragment() {
	COLOR = texture(TEXTURE, UV) + texture(emission_map, UV) * strength;
}

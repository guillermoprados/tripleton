shader_type canvas_item;

uniform float transparency : hint_range(0, 10) = 1.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 transparent_color = color * transparency;
	COLOR = transparent_color;
}

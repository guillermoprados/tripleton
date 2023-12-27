shader_type canvas_item;

uniform vec4 tint : source_color = vec4(1., 1., 0., 1.);
uniform float color_span : hint_range(0.1, 1.) = .3;
uniform float highlight_speed = 1.;
uniform float highlight_duration = 1.;
uniform float wait_duration = 5.;

uniform vec4 line_color : source_color = vec4(1);
uniform vec4 overlay_color : source_color = vec4(1);
uniform float line_thickness : hint_range(0, 10) = 1.0;

float luminance(vec4 colour) {
    return 1.0 - sqrt(0.299 * colour.r * colour.r + 0.587 * colour.g * colour.g + 0.114 * colour.b * colour.b);
}

void fragment() {
	
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
	
	float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	outline = min(outline, 1.0);
	
	vec4 color = texture(TEXTURE, UV);
	vec4 modulated_color = color * overlay_color;
	vec4 bordered_color = mix(modulated_color, overlay_color * line_color, outline - modulated_color.a);
	
	float time_in_cycle = mod(TIME, highlight_duration + wait_duration);

    // Check if it's in the highlight phase
    if (time_in_cycle < highlight_duration) {
        vec4 colour = bordered_color;
        float target = abs(sin(time_in_cycle / highlight_duration * PI * highlight_speed) * (1. + color_span));

        if (colour.a > 0.) {
            float lum = luminance(colour);
            float diff = abs(lum - target);
            float mx = clamp(1. - diff / color_span, 0., 1.);
            colour = mix(colour, tint, mx);
        }

        COLOR = colour;
    } else {
        // If not in the highlight phase, just use the original color
        COLOR = bordered_color;
    }
}

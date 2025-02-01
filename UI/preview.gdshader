shader_type canvas_item;

uniform sampler2D noise_map;

//uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float brightness = 0.8;
uniform float contrast = 1.5;
uniform float saturation = 1.8;

void fragment() {
    vec3 c = textureLod(noise_map, SCREEN_UV, 0.0).rgb;

    c.rgb = mix(vec3(0.0), c.rgb, brightness);
    c.rgb = mix(vec3(0.5), c.rgb, contrast);
    c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, saturation);

    COLOR.rgb = c;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

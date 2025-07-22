shader_type canvas_item;

uniform float blur_size : hint_range(0.0, 50.0) = 24.0;
uniform int samples : hint_range(1, 32) = 24;

void fragment() {
    vec2 uv = UV;
    vec4 col = vec4(0.0);
    float total = 0.0;

    vec2 tex_size = vec2(textureSize(TEXTURE, 0));

    for (int i = -samples; i <= samples; i++) {
        float weight = exp(-float(i * i) / (2.0 * max(blur_size, 0.001)));
        vec2 offset = vec2(float(i), 0.0) / tex_size;
        col += texture(TEXTURE, uv + offset) * weight;
        total += weight;
    }
    col /= total;

    vec4 horiz_blur = col;
    col = vec4(0.0);
    total = 0.0;

    for (int i = -samples; i <= samples; i++) {
        float weight = exp(-float(i * i) / (2.0 * max(blur_size, 0.001)));
        vec2 offset = vec2(0.0, float(i)) / tex_size;
        col += texture(TEXTURE, uv + offset) * weight;
        total += weight;
    }
    col /= total;

    COLOR = mix(horiz_blur, col, 0.5);
}

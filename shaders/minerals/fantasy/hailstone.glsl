// shaders/minerals/fantasy/hailstone.glsl
// HAILSTONE (Layered Ice)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Atmospheric)

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    float r = length(uv);

    // Concentric layers: clear ice / cloudy ice
    float layers = floor(r * 10.0);
    float layer_frac = fract(r * 10.0);

    // Alternate clear and cloudy
    bool clear_layer = mod(layers, 2.0) < 1.0;

    // Clear ice: transparent, slight blue
    vec3 clear_ice = vec3(0.85, 0.9, 0.95) * (0.9 + layer_frac * 0.2);

    // Cloudy ice: trapped air bubbles
    float bubbles = fbm(uv * 20.0 + layers);
    vec3 cloudy_ice = vec3(0.9, 0.9, 1.0) * (0.7 + bubbles * 0.3);

    vec3 color = clear_layer ? clear_ice : cloudy_ice;

    // Surface melt (outer layer)
    float melt = smoothstep(0.9, 1.0, r) * sin(u_time * 2.0) * 0.5 + 0.5;
    color = mix(color, vec3(0.9, 0.95, 1.0), melt * 0.3);

    gl_FragColor = vec4(color * smoothstep(1.0, 0.9, r), 1.0);
}

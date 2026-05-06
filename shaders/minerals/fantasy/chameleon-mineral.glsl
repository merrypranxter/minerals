// shaders/minerals/fantasy/chameleon-mineral.glsl
// CHAMELEON MINERAL (Adaptive Camouflage)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Fantasy)

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_environment;

// Sample environment color
vec3 environment_color(vec2 uv) {
    return texture2D(u_environment, uv * 0.5 + 0.5).rgb;
}

// Structural color matching
vec3 match_color(vec3 target, float accuracy) {
    // Structural color approximation
    float hue = atan(target.g - target.b, target.r - target.g) / 6.28;
    float sat = length(target.gb - target.r * 0.5);

    // Match with structural interference
    vec3 matched = 0.5 + 0.5 * cos(hue * 6.28 + vec3(0.0, 2.09, 4.19));
    matched = mix(vec3(0.5), matched, sat * 2.0);

    // Accuracy determines how well it matches
    return mix(target, matched, accuracy);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Mineral surface
    float surface = smoothstep(0.8, 0.7, length(uv));

    // Sample environment at different angles (like facets)
    vec3 env_front = environment_color(uv);
    vec3 env_left = environment_color(uv + vec2(0.1, 0.0));
    vec3 env_right = environment_color(uv - vec2(0.1, 0.0));

    // Facet-dependent color matching
    float facet = abs(fract(atan(uv.y, uv.x) * 3.0 / 3.14) - 0.5) * 2.0;
    vec3 color = mix(env_front, mix(env_left, env_right, facet), 0.3);

    // Match with structural color
    vec3 matched = match_color(color, 0.8);

    // Transition animation (slow adaptation)
    float adaptation = sin(u_time * 0.5) * 0.5 + 0.5;
    vec3 final = mix(env_front, matched, adaptation);

    // Surface texture
    float texture = fbm(uv * 10.0) * 0.1;
    final += texture;

    final *= surface;

    gl_FragColor = vec4(final, 1.0);
}

// shaders/minerals/selenite.glsl
// SELENITE (Desert Rose / Gypsum Flower)
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

// Desert rose petal SDF
float sdPetal(vec2 p, float angle, float length, float width) {
    vec2 local = p;
    local *= rot(-angle);
    // Flattened ellipse
    float d = length(local * vec2(1.0 / width, 1.0 / length)) - 1.0;
    return d;
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Cluster of petals radiating from center
    float cluster = 1e10;
    float num_petals = 8.0;

    for(float i = 0.0; i < num_petals; i++) {
        float angle = i / num_petals * 6.28318 + u_time * 0.05;
        float length = 0.6 + sin(i * 2.0) * 0.1;
        float width = 0.15 + cos(i * 3.0) * 0.05;

        float petal = sdPetal(uv, angle, length, width);
        cluster = smin(cluster, petal, 0.05);
    }

    // Gypsum is translucent white with silky luster
    float inside = smoothstep(0.02, -0.02, cluster);
    float edge = smoothstep(0.05, 0.0, abs(cluster));

    vec3 gypsum = vec3(0.95, 0.93, 0.9);
    vec3 shadow = vec3(0.7, 0.68, 0.65);
    vec3 highlight = vec3(1.0, 0.98, 0.95);

    vec3 final = mix(shadow, gypsum, inside);
    final += highlight * edge * 2.0; // Silky edge sheen

    // Sand matrix
    float sand = fbm(uv * 8.0 + 50.0);
    vec3 sand_color = vec3(0.8, 0.7, 0.5) * sand;
    final = mix(sand_color, final, inside + edge);

    gl_FragColor = vec4(final, 1.0);
}

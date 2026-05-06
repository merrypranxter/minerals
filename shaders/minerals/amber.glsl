// shaders/minerals/amber.glsl
// AMBER
// Source: Weird Guy Mineral Shader Corpus

// Volumetric absorption
float depth = (1.0 - dist) * shell;
vec3 honey = vec3(1.0, 0.7, 0.1);
vec3 cognac = vec3(0.4, 0.1, 0.0);
vec3 base_color = mix(honey, cognac, pow(depth, 2.0));

// Internal flow & debris (parallax)
for(int i = 1; i <= 4; i++) {
    float z = float(i) * 0.15;
    vec2 p_z = uv + viewDir.xy * z;
    float n = flow_noise(p_z * 5.0);
    debris += step(0.98, n) * (1.0 - z);
}

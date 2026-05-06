// shaders/minerals/fantasy/c9-thermoluminescence.glsl
// THERMOLUMINESCENCE (Heat-Induced Glow)
// Source: Weird Guy Mineral Shader Corpus (Pass 4)

vec3 thermoluminescence(float temperature, float trapped_energy) {
    // Glow starts at threshold temperature
    float threshold = 0.3;
    float glow = smoothstep(threshold, threshold + 0.2, temperature);

    // Color depends on mineral
    vec3 fluorite_glow = vec3(0.3, 0.9, 0.5); // Green
    vec3 calcite_glow = vec3(0.9, 0.3, 0.3);  // Red
    vec3 quartz_glow = vec3(0.9, 0.9, 1.0);   // Blue-white

    // Intensity proportional to trapped energy
    return quartz_glow * glow * trapped_energy * 3.0;
}

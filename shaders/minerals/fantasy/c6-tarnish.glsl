// shaders/minerals/fantasy/c6-tarnish.glsl
// TARNISH (Silver/Copper Oxidation)
// Source: Weird Guy Mineral Shader Corpus (Pass 4)

vec3 tarnish(vec3 base_metal, float exposure_time, float humidity) {
    // Thickness increases with exposure
    float thickness = exposure_time * humidity * 0.1;

    // Interference colors
    vec3 oxide = 0.5 + 0.5 * cos(thickness * 10.0 + vec3(0.0, 2.09, 4.19));

    // Mix: fresh metal → tarnished
    float tarnish_amount = smoothstep(0.0, 10.0, thickness);

    return mix(base_metal, oxide, tarnish_amount);
}

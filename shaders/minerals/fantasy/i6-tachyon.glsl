// shaders/minerals/fantasy/i6-tachyon.glsl
// TACHYON CRYSTAL (Faster Than Light)
// Source: Weird Guy Mineral Shader Corpus (Pass 4)

// Cherenkov radiation: blue glow when particle exceeds light speed in medium
vec3 cherenkov(vec2 p, vec2 particle_pos, vec2 particle_vel, float c_medium) {
    float v = length(particle_vel);

    // Only glow if v > c_medium
    float superluminal = step(c_medium, v);

    // Cone angle: cos(theta) = c_medium / v
    float cos_theta = c_medium / (v + 0.001);

    // Distance from Cherenkov cone
    vec2 to_particle = p - particle_pos;
    float particle_angle = dot(normalize(to_particle), normalize(particle_vel));
    float cone_dist = abs(particle_angle - cos_theta);

    // Blue glow
    float glow = exp(-cone_dist * cone_dist * 100.0) * superluminal;

    return vec3(0.2, 0.5, 1.0) * glow * 3.0;
}
